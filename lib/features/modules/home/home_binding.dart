import 'package:get/get.dart';
import 'package:inventory_platform/features/data/services/auth_service.dart';
import 'package:inventory_platform/features/modules/home/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthService>(() => AuthService());
    Get.lazyPut<HomeController>(() => HomeController());
  }
}
