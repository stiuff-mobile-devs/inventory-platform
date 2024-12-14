import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:get/get.dart';

class AuthService extends GetxService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  User? get currentUser => _auth.currentUser;

  Future<bool> signInWithGoogle() async {
    try {
      if (GetPlatform.isWeb) {
        // Fluxo de login para a Web
        final GoogleAuthProvider googleProvider = GoogleAuthProvider();
        await _auth.signInWithPopup(googleProvider);
      } else {
        // Fluxo de login para dispositivos móveis
        final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

        if (googleUser == null) {
          return false;
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
      Get.snackbar('Erro', 'Falha no login com Google: $e',
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      await _googleSignIn.signOut();
    } catch (e) {
      Get.snackbar('Erro', 'Erro ao realizar logout: $e');
    }
  }

  bool get isUserLoggedIn => _auth.currentUser != null;
}
