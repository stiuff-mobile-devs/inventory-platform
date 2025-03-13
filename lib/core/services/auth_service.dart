import 'package:flutter/material.dart';
import 'package:get/get_utils/src/platform/platform.dart';
import 'package:inventory_platform/core/services/connection_service.dart';
import 'package:inventory_platform/core/utils/auth/auth_error.dart';
import 'package:inventory_platform/core/utils/auth/auth_warning.dart';
import 'package:inventory_platform/core/services/error_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:inventory_platform/core/services/warning_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inventory_platform/core/debug/logger.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final ErrorService _errorService = ErrorService();
  final WarningService _warningService = WarningService();
  final ConnectionService _connectionService = ConnectionService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? _cachedProfileImageUrl;

  User? get currentUser => _auth.currentUser;
  bool get isUserLoggedIn => _auth.currentUser != null;

  AuthService() {
    try {
      if (GetPlatform.isWeb) {
        _auth.setPersistence(Persistence.LOCAL);
      }
    } catch (e, stackTrace) {
      Logger.error("Erro ao definir persistência: $e", stackTrace);
    }
  }

  Future<String?> getProfileImageUrl() async {
    if (_cachedProfileImageUrl != null) {
      return _cachedProfileImageUrl;
    }

    try {
      final User? user = _auth.currentUser;

      if (user == null) {
        throw AuthError("Usuário não autenticado.");
      }

      if (user.photoURL != null && user.photoURL!.isNotEmpty) {
        _cachedProfileImageUrl = user.photoURL!;
        return _cachedProfileImageUrl;
      }

      if (!GetPlatform.isWeb) {
        final GoogleSignInAccount? googleUser =
            await _googleSignIn.signInSilently();
        if (googleUser != null && googleUser.photoUrl != null) {
          _cachedProfileImageUrl = googleUser.photoUrl;
          return _cachedProfileImageUrl;
        }
      }

      throw AuthWarning("Imagem de perfil não encontrada.");
    } catch (e) {
      if (e is AuthError || e is AuthWarning) {
        _warningService.handleWarning(e as Exception);
      } else {
        _errorService
            .handleError(Exception("Erro ao obter a URL da imagem de perfil."));
      }
      return null;
    }
  }

  Future<bool> signInWithGoogle() async {
    bool success = false;

    Logger.info("signInWithGoogle - Starting authentication flow");

    final bool hasInternet = await _connectionService.checkInternetConnection();
    if (!hasInternet) {
      Logger.info("signInWithGoogle - No internet connection");
      throw NetworkError();
    }

    Logger.info("signInWithGoogle - Internet connection verified");

    UserCredential userCredential;

    if (GetPlatform.isWeb) {
      Logger.info(
          "signInWithGoogle - Web platform detected, using popup signin");
      final GoogleAuthProvider googleProvider = GoogleAuthProvider();
      userCredential = await _auth.signInWithPopup(googleProvider);
      Logger.info("signInWithGoogle - Web signin completed");
    } else {
      Logger.info(
          "signInWithGoogle - Mobile platform detected, launching Google SignIn");
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      Logger.info("signInWithGoogle - Google SignIn launched");
      if (googleUser == null) {
        Logger.info("signInWithGoogle - Sign in was interrupted by user");
        throw SignInInterruptionWarning();
      }

      Logger.info(
          "signInWithGoogle - Google user obtained: ${googleUser.email}");

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      Logger.info("signInWithGoogle - Google authentication obtained");

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      Logger.info("signInWithGoogle - Auth credential created");

      userCredential = await _auth.signInWithCredential(credential);
      Logger.info(
          "signInWithGoogle - Firebase signin with credential completed");
    }

    final User? user = userCredential.user;
    if (user == null || user.email == null) {
      Logger.info("signInWithGoogle - Failed to obtain user email");
      throw AuthError("Erro ao obter email do usuário.");
    }

    Logger.info("signInWithGoogle - User retrieved: ${user.email}");

    bool isAllowed = await _isEmailAllowed(user.email!);
    Logger.info("signInWithGoogle - Email allowed check result: $isAllowed");

    success = true;

    if (!isAllowed) {
      Logger.info("signInWithGoogle - Email not allowed, signing out user");
      await _auth.signOut();
      await _googleSignIn.signOut();
      success = false;
      _errorService.handleError(
        AuthError("Seu email não está autorizado a acessar este sistema."),
      );
      Logger.info(
          "signInWithGoogle - User signed out due to unauthorized email");
    } else {
      Logger.info("signInWithGoogle - Authentication successful");
    }

    Logger.info("signInWithGoogle - Returning success=$success");
    return success;
  }

  Future<bool> _isEmailAllowed(String email) async {
    final querySnapshot = await _firestore.collection("allowed_users").get();
    for (var doc in querySnapshot.docs) {
      if (doc.data()['email'] == email) {
        return true;
      }
    }
    return false;
  }

  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
    _cachedProfileImageUrl = null;
  }
}
