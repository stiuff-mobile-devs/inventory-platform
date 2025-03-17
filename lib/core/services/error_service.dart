import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:inventory_platform/core/debug/logger.dart';
import '../utils/auth/auth_error.dart';

class ErrorService {
  void handleError(Exception e) {
    String errorMessage;
    String originalError = e.toString();

    if (e is InvalidCredentialsError) {
      errorMessage = e.message;
    } else if (e is NetworkError) {
      errorMessage = e.message;
    } else if (e is AuthError) {
      errorMessage = e.message;
    } else {
      errorMessage = "Ocorreu um erro inesperado.";
    }

    Logger.error(
        "ErrorService: - $errorMessage\nOriginal error: $originalError",
        StackTrace.current);

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
        title: 'Erro',
        message: kDebugMode ? originalError : errorMessage,
        contentType: ContentType.failure,
      ),
    );
  }
}
