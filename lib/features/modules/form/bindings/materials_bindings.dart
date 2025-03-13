import 'package:get/get.dart';
import 'package:inventory_platform/features/modules/form/controllers/materials_controller.dart';

class MaterialsBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MaterialsController>(() => MaterialsController());
  }
}