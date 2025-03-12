import 'package:get/get.dart';
import 'package:inventory_platform/features/modules/form/controllers/departaments_controller.dart';

class DepartamentsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DepartamentsController>(() => DepartamentsController());
  }
}