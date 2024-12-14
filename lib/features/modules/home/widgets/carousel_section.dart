import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:inventory_platform/features/modules/home/home_controller.dart';

class CarouselSection extends StatelessWidget {
  final HomeController controller;

  const CarouselSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Stack(
        alignment: Alignment.bottomCenter,
        children: [
          CarouselSlider(
            options: CarouselOptions(
              height: 250,
              viewportFraction: 0.8,
              enableInfiniteScroll: true,
              enlargeCenterPage: false,
              autoPlay: false,
              onPageChanged: (index, reason) {
                controller.updateCarouselIndex(index);
              },
            ),
            items: List.generate(
              10,
              (index) => _buildCarouselItem(index),
            ),
          ),
          Positioned(
            bottom: 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                10,
                (index) =>
                    _buildIndicator(controller.carouselIndex.value, index),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCarouselItem(int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
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
          'Item ${index + 1}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black54,
            fontSize: 16,
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
