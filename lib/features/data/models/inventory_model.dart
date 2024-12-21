import 'package:inventory_platform/features/data/models/carousel_item_model.dart';

class InventoryModel implements CarouselItemModel {
  @override
  final String title;
  @override
  final String description;
  @override
  final String? imagePath;

  final String organizationId;

  InventoryModel({
    required this.title,
    required this.description,
    this.imagePath,
    required this.organizationId,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'imagePath': imagePath,
      'organizationId': organizationId,
    };
  }

  factory InventoryModel.fromJson(Map<String, dynamic> json) {
    return InventoryModel(
      title: json['title'] as String,
      description: json['description'] as String,
      imagePath: json['imagePath'] as String?,
      organizationId: json['organizationId'] as String,
    );
  }
}
