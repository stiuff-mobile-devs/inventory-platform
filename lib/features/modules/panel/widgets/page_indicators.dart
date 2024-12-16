import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PageIndicatorsController extends GetxController {
  var pageIndex = 0.obs;

  final List<String> inventoryItems =
      List.generate(10, (index) => 'Inventário ${index + 1}');
  final int itemsPerPage = 6;

  int get pageCount => (inventoryItems.length / itemsPerPage).ceil();

  void updatePageIndex(int index) {
    pageIndex.value = index;
  }
}

class PageIndicatorsSection extends StatelessWidget {
  final PageIndicatorsController controller;

  const PageIndicatorsSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Obx(
        () => Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(controller.pageCount, (index) {
            return GestureDetector(
              onTap: () {
                controller.updatePageIndex(index);
              },
              child: Container(
                width: 8.0,
                height: 8.0,
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: controller.pageIndex.value == index
                      ? Colors.blue
                      : Colors.grey.shade400,
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
