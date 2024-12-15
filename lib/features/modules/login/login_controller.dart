import 'package:get/get.dart';
import 'package:inventory_platform/features/data/services/error_service.dart';
import 'package:inventory_platform/features/data/services/auth_service.dart';
import 'package:inventory_platform/routes/routes.dart';

class LoginController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final ErrorService _errorService = Get.find<ErrorService>();

  Future<bool> handleGoogleSignIn() async {
    try {
      final success = await _authService.signInWithGoogle();
      if (success) {
        Get.offAllNamed(AppRoutes.home);
      }
      return success;
    } catch (e) {
      _errorService.handleError(e as Exception);
      return false;
    }
  }
}
