import 'package:get/get.dart';
// import 'package:inventory_platform/features/data/services/connection_service.dart';
import 'package:inventory_platform/features/data/services/auth_service.dart';
import 'package:inventory_platform/features/data/services/error_service.dart';
import 'package:inventory_platform/features/data/services/warning_service.dart';
// import 'package:inventory_platform/features/modules/controllers/connection_controller.dart';

class CoreBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthService>(() => AuthService());
    // Get.lazyPut<ConnectionService>(() => ConnectionService());
    // Get.lazyPut<ConnectionController>(() => ConnectionController());
    Get.lazyPut<ErrorService>(() => ErrorService());
    Get.lazyPut<WarningService>(() => WarningService());
  }
}
