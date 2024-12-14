import 'package:flutter/material.dart';
import 'package:inventory_platform/features/modules/home/home_controller.dart';

class InventoryGridSection extends StatelessWidget {
  final HomeController controller;

  const InventoryGridSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final inventoryItems = controller.inventoryItems;
    final pageCount = (inventoryItems.length / controller.itemsPerPage).ceil();

    return LayoutBuilder(
      builder: (context, constraints) {
        final isPortrait = controller.isPortrait;
        final crossAxisCount = isPortrait ? 2 : 3;
        const spacing = 10.0;
        const childAspectRatio = 1.0;

        final itemWidth =
            (constraints.maxWidth - (crossAxisCount - 1) * spacing) /
                crossAxisCount;

        final itemHeight = itemWidth / childAspectRatio;

        final rowsPerPage = (controller.itemsPerPage / crossAxisCount).ceil();

        final totalHeight = (rowsPerPage * itemHeight) + ((rowsPerPage - 1));
        return SizedBox(
          height: totalHeight,
          child: PageView.builder(
            controller: PageController(),
            itemCount: pageCount,
            onPageChanged: (index) {
              controller.updatePageIndex(index);
            },
            itemBuilder: (context, pageIndex) {
              int startIndex = pageIndex * controller.itemsPerPage;
              int endIndex = (pageIndex + 1) * controller.itemsPerPage;
              endIndex = endIndex > inventoryItems.length
                  ? inventoryItems.length
                  : endIndex;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: spacing,
                    mainAxisSpacing: spacing,
                    childAspectRatio: childAspectRatio,
                  ),
                  itemCount: endIndex - startIndex,
                  itemBuilder: (context, index) {
                    int actualIndex = startIndex + index;
                    return _buildInventoryItem(inventoryItems[actualIndex]);
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildInventoryItem(String itemName) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Text(
          itemName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black54,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
