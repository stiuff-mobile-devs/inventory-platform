import 'package:get/get.dart';
import 'package:inventory_platform/features/modules/home/home_controller.dart';
import 'package:inventory_platform/features/common/controllers/carousel_section_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
    Get.put(CarouselSectionController());
  }
}
