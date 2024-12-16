import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventory_platform/features/modules/panel/widgets/inventory_grid.dart';
import 'package:inventory_platform/features/modules/panel/widgets/page_indicators.dart';
import 'package:inventory_platform/features/modules/panel/panel_controller.dart';

class PanelBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PanelController>(() => PanelController());
    Get.lazyPut<CarouselController>(() => CarouselController());
    Get.lazyPut<InventoryGridController>(() => InventoryGridController());
    Get.lazyPut<PageIndicatorsController>(() => PageIndicatorsController());
  }
}
