import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:inventory_platform/core/services/error_service.dart';
import 'package:inventory_platform/data/models/credentials_model.dart';
import 'package:inventory_platform/routes/routes.dart';

class RegisterController extends GetxController {
  final ErrorService _errorService = Get.find<ErrorService>();

  Future<bool> handleRegister(UserCredentialsModel user) async {
    try {
      UserCredential credentials = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: user.email,
        password: user.password!,
      );

      String uid = credentials.user!.uid;
      await FirebaseFirestore.instance.collection("users").doc(uid).set({
        "name": user.name,
        "email": user.email,
        "created_at": FieldValue.serverTimestamp()
      });

      Get.offAllNamed(AppRoutes.home);
      return true;
    } catch (e) {
      _errorService.handleError(e as Exception);
      return false;
    }
  }
}
