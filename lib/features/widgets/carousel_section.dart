import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:inventory_platform/features/data/models/carousel_item_model.dart';

class CarouselSectionController extends GetxController {
  var carouselIndex = 0.obs;
  var isHovered = false.obs;

  void updateCarouselIndex(int index) {
    carouselIndex.value = index;
  }

  void setHovered(bool value) {
    isHovered.value = value;
  }
}

class CarouselSection extends StatelessWidget {
  final CarouselSectionController controller;
  final List<CarouselItemModel> items;

  final bool? isExpanded;

  const CarouselSection({
    super.key,
    this.isExpanded,
    required this.controller,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Stack(
        alignment: Alignment.bottomCenter,
        children: [
          CarouselSlider(
            options: CarouselOptions(
              height: (isExpanded ?? false)
                  ? MediaQuery.of(context).size.height * 0.75
                  : MediaQuery.of(context).size.height * 0.25,
              viewportFraction: 0.8,
              enableInfiniteScroll: true,
              enlargeCenterPage: false,
              autoPlay: false,
              onPageChanged: (index, reason) {
                controller.updateCarouselIndex(index);
              },
            ),
            items:
                items.map((item) => _buildCarouselItem(item, context)).toList(),
          ),
          Positioned(
            bottom: 10,
            child: Opacity(
              opacity: !controller.isHovered.value ? 1.0 : 0.1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  items.length,
                  (index) =>
                      _buildIndicator(controller.carouselIndex.value, index),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildCarouselItem(CarouselItemModel item, BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        controller.isHovered.value = true;
        Future.delayed(
          const Duration(seconds: 3),
          () => controller.isHovered.value = false,
        );
      },
      child: MouseRegion(
        onEnter: (_) => controller.setHovered(true),
        onExit: (_) => controller.setHovered(false),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
            image: item.imagePath.isNotEmpty
                ? DecorationImage(
                    image: NetworkImage(item.imagePath),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
                bottom: controller.isHovered.value ? 0 : -40,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: controller.isHovered.value ? 1.0 : 0.0,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(10.0),
                        bottomRight: Radius.circular(0.0),
                        topLeft: Radius.circular(10.0),
                        bottomLeft: Radius.circular(0.0),
                      ),
                      color: Colors.black.withOpacity(0.6),
                    ),
                    padding: const EdgeInsets.all(8.0),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: (isExpanded ?? false) ? 20 : 16,
                            ),
                          ),
                          Text(
                            item.description,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: (isExpanded ?? false) ? 16 : 12,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIndicator(int currentIndex, int index) {
    return Container(
      width: 8.0,
      height: 8.0,
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: currentIndex == index ? Colors.blue : Colors.grey.shade400,
      ),
    );
  }
}
