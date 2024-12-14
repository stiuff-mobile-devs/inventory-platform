import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventory_platform/features/modules/home/home_controller.dart';

class PageIndicatorsSection extends StatelessWidget {
  final HomeController controller;

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
