import 'package:get/get.dart';
import 'package:inventory_platform/features/data/services/auth_service.dart';
import 'package:inventory_platform/features/modules/login/login_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthService>(() => AuthService());
    Get.lazyPut<LoginController>(() => LoginController());
  }
}
