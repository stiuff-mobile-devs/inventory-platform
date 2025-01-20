import 'package:get/get.dart';
import 'package:inventory_platform/features/modules/form/form_controller.dart';

class FormBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FormController>(() => FormController());
  }
}
