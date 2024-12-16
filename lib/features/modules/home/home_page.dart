import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventory_platform/core/services/mock_service.dart';
import 'package:inventory_platform/features/widgets/base_scaffold.dart';
// import 'package:inventory_platform/features/modules/home/home_controller.dart';
import 'package:inventory_platform/features/widgets/carousel_section.dart' as w;

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // final controller = Get.find<HomeController>();
    final carouselController = Get.find<w.CarouselSectionController>();
    final mockService = Get.find<MockService>();

    return BaseScaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Minhas Organizações', context),
            const SizedBox(height: 16),
            w.CarouselSection(
              isExpanded: true,
              controller: carouselController,
              items: mockService.organizationsList,
            ),
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
