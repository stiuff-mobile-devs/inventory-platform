import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventory_platform/core/utils/auth/auth_warning.dart';

class WarningService {
  void handleWarning(Exception e) {
    String? warningMessage;

    if (e is SignInInterruptionWarning) {
      warningMessage = e.message;
    }

    if (e is FirebaseAuthException) {
      warningMessage = e.message;
    }

    if (warningMessage != null) {
      debugPrint("WarningService: - $warningMessage");

      Get.snackbar(
        '',
        '',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.transparent,
        barBlur: 0,
        borderRadius: 10,
        isDismissible: true,
        margin: const EdgeInsets.all(16),
        messageText: AwesomeSnackbarContent(
          title: 'Aviso',
          message: warningMessage,
          contentType: ContentType.warning,
        ),
      );
    }
  }
}
