import 'package:get/get.dart';
import 'package:inventory_platform/features/data/services/auth_service.dart';
import 'package:inventory_platform/features/widgets/loading_dialog.dart';
import 'package:inventory_platform/routes/routes.dart';

class LoginController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  Future<bool> handleGoogleSignIn() async {
    Get.dialog(const LoadingDialog(), barrierDismissible: false);

    final success = await _authService.signInWithGoogle();

    Get.back();
    if (success) {
      Get.offAllNamed(AppRoutes.home);
    } else {
      Get.snackbar(
        'Erro',
        'Falha no login. Tente novamente.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
    return success;
  }
}
