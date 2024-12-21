import 'package:inventory_platform/features/data/models/carousel_item_model.dart';

class OrganizationModel implements CarouselItemModel {
  @override
  final String title;
  @override
  final String description;
  @override
  final String? imagePath;

  final String id;

  OrganizationModel({
    required this.title,
    required this.description,
    this.imagePath,
    required this.id,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'imagePath': imagePath,
      'id': id,
    };
  }

  factory OrganizationModel.fromJson(Map<String, dynamic> json) {
    return OrganizationModel(
      title: json['title'] as String,
      description: json['description'] as String,
      imagePath: json['imagePath'] as String,
      id: json['id'] as String,
    );
  }
}
