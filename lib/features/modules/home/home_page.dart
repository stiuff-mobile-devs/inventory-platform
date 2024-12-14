import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventory_platform/features/modules/home/widgets/inventory_grid.dart';
import 'package:inventory_platform/features/modules/home/widgets/page_indicators.dart';
import 'package:inventory_platform/widgets/base_scaffold.dart';
import 'package:inventory_platform/features/modules/home/home_controller.dart';
import 'package:inventory_platform/features/modules/home/widgets/carousel_section.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find();

    return BaseScaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Acessados Recentemente', context),
            const SizedBox(height: 16),
            CarouselSection(controller: controller),
            const SizedBox(height: 20),
            _buildSectionTitle('Meus Inventários', context),
            const SizedBox(height: 16),
            InventoryGridSection(controller: controller),
            PageIndicatorsSection(controller: controller),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: const Color.fromARGB(255, 36, 36, 36),
            fontSize: 20,
          ),
    );
  }
}
