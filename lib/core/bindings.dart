import 'package:get/get.dart';
import 'package:inventory_platform/core/services/mock_service.dart';
// import 'package:inventory_platform/features/data/services/connection_service.dart';
import 'package:inventory_platform/features/data/services/auth_service.dart';
import 'package:inventory_platform/core/services/error_service.dart';
import 'package:inventory_platform/core/services/warning_service.dart';
import 'package:inventory_platform/features/data/services/connection_service.dart';
import 'package:inventory_platform/features/widgets/controllers/connection_controller.dart';
import 'package:inventory_platform/features/widgets/controllers/sidebar_controller.dart';
// import 'package:inventory_platform/features/modules/controllers/connection_controller.dart';

class CoreBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthService());
    Get.put(ConnectionService());
    Get.put(ConnectionController());
    Get.put(ErrorService());
    Get.put(WarningService());
    Get.put(SidebarController());
    Get.put(MockService());
  }
}
