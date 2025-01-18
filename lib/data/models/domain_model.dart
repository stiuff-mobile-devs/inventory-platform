import 'package:inventory_platform/data/models/generic_list_item_model.dart';

class DomainModel {
  final String id;
  final String title;
  final int isActive;
  final String? description;
  final String? location;
  final int? capacity;
  final DateTime? createdAt;
  final DateTime? lastUpdatedAt;
  final Map<String, dynamic>? attributes;

  DomainModel({
    required this.id,
    required this.title,
    required this.isActive,
    this.description,
    this.location,
    this.capacity,
    DateTime? createdAt,
    DateTime? lastUpdatedAt,
    this.attributes,
  })  : createdAt = createdAt ?? DateTime.now(),
        lastUpdatedAt = lastUpdatedAt ?? DateTime.now();

  factory DomainModel.fromJson(Map<String, dynamic> json) {
    return DomainModel(
        id: json['id'],
        title: json['title'],
        isActive: json['isActive'],
        description: json['description'],
        location: json['location'],
        capacity: json['capacity'],
        createdAt: DateTime.parse(json['createdAt']),
        lastUpdatedAt: DateTime.parse(json['lastUpdatedAt']),
        attributes: Map<String, dynamic>.from(json['attributes']));
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'status': isActive,
        'description': description,
        'location': location,
        'capacity': capacity,
        'createdAt': createdAt?.toIso8601String(),
        'lastUpdatedAt': lastUpdatedAt?.toIso8601String(),
        'attributes': attributes,
      };

  static List<GenericListItemModel> turnAllIntoGenericListItemModel(
      List<DomainModel> inList) {
    return inList.map((originalItem) {
      return GenericListItemModel(
        id: originalItem.id,
        upperHeaderField: originalItem.title,
        lowerHeaderField: originalItem.description,
        isActive: originalItem.isActive,
        initialDate: originalItem.createdAt,
        lastUpdatedAt: originalItem.lastUpdatedAt,
      );
    }).toList();
  }
}
