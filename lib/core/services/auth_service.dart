import 'package:flutter/material.dart';
import 'package:get/get_utils/src/platform/platform.dart';
import 'package:inventory_platform/core/services/connection_service.dart';
import 'package:inventory_platform/core/utils/auth/auth_error.dart';
import 'package:inventory_platform/core/utils/auth/auth_warning.dart';
import 'package:inventory_platform/core/services/error_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:inventory_platform/core/services/warning_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final ErrorService _errorService = ErrorService();
  final WarningService _warningService = WarningService();
  final ConnectionService _connectionService = ConnectionService();

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

  Future<bool> signInWithGoogle() async {
    bool success = false;

    final bool hasInternet = await _connectionService.checkInternetConnection();
    if (!hasInternet) {
      throw NetworkError();
    }

    if (GetPlatform.isWeb) {
      final GoogleAuthProvider googleProvider = GoogleAuthProvider();
      await _auth.signInWithPopup(googleProvider);
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

      await _auth.signInWithCredential(credential);
    }

    success = true;

    return success;
  }

  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
    _cachedProfileImageUrl = null;
  }
}
