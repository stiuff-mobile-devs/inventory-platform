import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/utils/auth/auth_error.dart';

class ErrorService {
  void handleError(Exception e) {
    String errorMessage = "Erro desconhecido.";

    if (e is InvalidCredentialsError) {
      errorMessage = e.message;
    } else if (e is NetworkError) {
      errorMessage = e.message;
    } else {
      errorMessage = "Ocorreu um erro inesperado.";
    }

    debugPrint("ErrorService: - $errorMessage");

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
        message: errorMessage,
        contentType: ContentType.failure,
      ),
    );
  }
}
