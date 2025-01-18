import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:inventory_platform/data/providers/utils_provider.dart';
import 'package:inventory_platform/data/models/user_model.dart';
import 'package:inventory_platform/data/repositories/user_repository.dart';

import 'error_service.dart';
import 'connection_service.dart';
import 'warning_service.dart';
import '../utils/auth/auth_error.dart';
import '../utils/auth/auth_warning.dart';

class AuthService {
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;
  final ErrorService _errorService;
  final WarningService _warningService;
  final ConnectionService _connectionService;

  final UtilsProvider _utilsProvider;

  final UserRepository _userRepository = Get.find<UserRepository>();

  String? _cachedProfileImageUrl;

  User? get currentUser => _auth.currentUser;
  bool get isUserLoggedIn => _auth.currentUser != null;

  AuthService({
    required FirebaseAuth firebaseAuth,
    required GoogleSignIn googleSignIn,
    required ErrorService errorService,
    required WarningService warningService,
    required ConnectionService connectionService,
    required UtilsProvider utilsProvider,
  })  : _auth = firebaseAuth,
        _googleSignIn = googleSignIn,
        _errorService = errorService,
        _warningService = warningService,
        _connectionService = connectionService,
        _utilsProvider = utilsProvider {
    _initializePersistence();
  }

  void _initializePersistence() {
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
    if (_cachedProfileImageUrl != null) return _cachedProfileImageUrl;

    try {
      final User? user = currentUser;

      if (user == null) throw AuthError("Usuário não autenticado.");
      if (user.photoURL != null && user.photoURL!.isNotEmpty) {
        _cachedProfileImageUrl = user.photoURL;
        return _cachedProfileImageUrl;
      }

      if (!GetPlatform.isWeb) {
        final GoogleSignInAccount? googleUser =
            await _googleSignIn.signInSilently();
        if (googleUser?.photoUrl != null) {
          _cachedProfileImageUrl = googleUser!.photoUrl;
          return _cachedProfileImageUrl;
        }
      }

      throw AuthWarning("Imagem de perfil não encontrada.");
    } catch (e) {
      _handleErrorOrWarning(e, "Erro ao obter a URL da imagem de perfil.");
      return null;
    }
  }

  Future<bool> signInWithGoogle() async {
    bool success = false;

    await _utilsProvider.retryWithExponentialBackoff(() async {
      final hasInternet = await _connectionService.checkInternetConnection();
      if (!hasInternet) throw NetworkError();

      if (GetPlatform.isWeb) {
        final GoogleAuthProvider googleProvider = GoogleAuthProvider();
        await _auth.signInWithPopup(googleProvider);
      } else {
        final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
        if (googleUser == null) throw SignInInterruptionWarning();

        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        await _auth.signInWithCredential(credential);
      }

      success = true;

      if (success) {
        final user = _auth.currentUser;
        if (user != null) {
          final existingUser = _userRepository.getUserById(user.uid);
          if (existingUser == null) {
            final userModel = UserModel(
              id: user.uid,
              name: user.displayName ?? 'Unknown',
              email: user.email ?? 'Unknown',
              profileImageUrl: user.photoURL,
            );
            _userRepository.addUser(userModel);
          }
        }
      }
    });

    return success;
  }

  Future<void> signOut() async {
    await _utilsProvider.retryWithExponentialBackoff(() async {
      await _auth.signOut();
      if (!GetPlatform.isWeb) await _googleSignIn.signOut();
      _cachedProfileImageUrl = null;
    });
  }

  void _handleErrorOrWarning(dynamic e, String defaultErrorMessage) {
    if (e is AuthWarning) {
      _warningService.handleWarning(e as Exception);
    } else if (e is AuthError) {
      _errorService.handleError(Exception(defaultErrorMessage));
    }
  }
}
