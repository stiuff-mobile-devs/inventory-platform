import 'package:flutter/material.dart';
import 'package:get/get_utils/src/platform/platform.dart';
import 'package:inventory_platform/core/utils/auth/auth_error.dart';
import 'package:inventory_platform/core/utils/auth/auth_warning.dart';
import 'package:inventory_platform/core/services/error_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:inventory_platform/features/data/services/connection_service.dart';
import 'package:inventory_platform/core/services/warning_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final ErrorService _errorService = ErrorService();
  final WarningService _warningService = WarningService();
  final ConnectionService _connectionService = ConnectionService();

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

  Future<bool> signInWithGoogle() async {
    try {
      final bool hasInternet =
          await _connectionService.checkInternetConnection();
      if (!hasInternet) {
        throw NetworkError();
      }

      if (GetPlatform.isWeb) {
        // Fluxo de login para a Web
        final GoogleAuthProvider googleProvider = GoogleAuthProvider();
        await _auth.signInWithPopup(googleProvider);
      } else {
        // Fluxo de login para dispositivos móveis
        final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

        if (googleUser == null) {
          throw UserCancelledWarning();
        }

        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        await _auth.signInWithCredential(credential);
      }

      return true;
    } catch (e) {
      if (e is AuthError) {
        _errorService.handleError(e);
      } else if (e is AuthWarning) {
        _warningService.handleWarning(e);
      } else {
        _errorService.handleError(Exception('Erro desconhecido.'));
      }
      return false;
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      await _googleSignIn.signOut();
    } catch (e) {
      if (e is AuthError) {
        _errorService.handleError(e);
      } else if (e is AuthWarning) {
        _warningService.handleWarning(e);
      } else {
        _errorService.handleError(Exception('Erro desconhecido.'));
      }
    }
  }
}
