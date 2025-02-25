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
      debugPrint("Erro ao definir persistência: $e");
      debugPrint(stackTrace.toString());
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

  Future<bool> signInWithEmailPassword(String email, String password) async {
    bool success = false;

    final bool hasInternet = await _connectionService.checkInternetConnection();
    if (!hasInternet) {
      throw NetworkError();
    }

    try {
      final credential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      success = true;
      return success;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        throw AuthError("Senha incorreta");
      }
      success = false;
    }

    return success;
  }

  Future<bool> signInWithGoogle() async {
    bool success = false;

    final bool hasInternet = await _connectionService.checkInternetConnection();
    if (!hasInternet) {
      throw NetworkError();
    }

    UserCredential userCredential;

    if (GetPlatform.isWeb) {
      final GoogleAuthProvider googleProvider = GoogleAuthProvider();
      userCredential = await _auth.signInWithPopup(googleProvider);
    } else {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw SignInInterruptionWarning();
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      userCredential = await _auth.signInWithCredential(credential);
    }

    final User? user = userCredential.user;
    if (user == null || user.email == null) {
      throw AuthError("Erro ao obter email do usuário.");
    }

    bool isAllowed = await _isEmailAllowed(user.email!);

    success = true;

    if (!isAllowed) {
      await _auth.signOut();
      await _googleSignIn.signOut();
      success = false;
      _errorService.handleError(
        AuthError("Seu email não está autorizado a acessar este sistema."),
      );
    }

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
