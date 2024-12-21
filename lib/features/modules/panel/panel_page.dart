import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventory_platform/core/services/mock_service.dart';
import 'package:inventory_platform/features/data/models/organization_model.dart';
import 'package:inventory_platform/features/widgets/carousel_section.dart' as w;
import 'package:inventory_platform/features/modules/panel/widgets/inventory_grid.dart';
import 'package:inventory_platform/features/modules/panel/widgets/page_indicators.dart';
// import 'package:inventory_platform/features/modules/panel/panel_controller.dart';
import 'package:inventory_platform/features/widgets/base_scaffold.dart';

class PanelPage extends StatelessWidget {
  const PanelPage({super.key});

  @override
  Widget build(BuildContext context) {
    final OrganizationModel organization = Get.arguments;

    // final controller = Get.find<PanelController>();
    final carouselController = Get.find<w.CarouselSectionController>();
    final pageIndicatorsController = Get.find<PageIndicatorsController>();
    final inventoryGridController = Get.find<InventoryGridController>();
    final mockService = Get.find<MockService>();

    return BaseScaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              organization.title,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 10),
            Text(
              organization.description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 20),
            // if (organization.imagePath != null)
            //   Image.asset(
            //     organization.imagePath!,
            //     fit: BoxFit.cover,
            //     width: double.infinity,
            //   ),
            _buildSectionTitle('Acessados Recentemente', context),
            const SizedBox(height: 16),
            w.CarouselSection(
              isExpanded: false,
              controller: carouselController,
              items: mockService.getInventoriesForOrganization(organization.id),
            ),
            const SizedBox(height: 20),
            _buildSectionTitle('Meus Inventários', context),
            const SizedBox(height: 16),
            InventoryGridSection(controller: inventoryGridController),
            PageIndicatorsSection(
              controller: pageIndicatorsController,
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
