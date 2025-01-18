import 'package:inventory_platform/features/data/models/generic_list_item_model.dart';

class InventoryModel {
  final String id;
  final String title;
  final String? description;
  final String revisionNumber;
  final int isActive;
  final DateTime? createdAt;
  final DateTime? lastUpdatedAt;

  InventoryModel({
    required this.id,
    required this.title,
    this.description,
    this.createdAt,
    DateTime? lastUpdatedAt,
    required this.revisionNumber,
    required this.isActive,
  }) : lastUpdatedAt = lastUpdatedAt ?? DateTime.now();

  factory InventoryModel.fromJson(Map<String, dynamic> json) {
    return InventoryModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      revisionNumber: json['revisionNumber'],
      isActive: json['isActive'],
      createdAt: DateTime.parse(json['openedAt']),
      lastUpdatedAt: DateTime.parse(json['lastUpdatedAt']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'isActive': isActive,
        'description': description,
        'openedAt': createdAt?.toIso8601String(),
        'lastUpdatedAt': lastUpdatedAt?.toIso8601String(),
        'revisionNumber': revisionNumber,
      };

  static List<GenericListItemModel> turnAllIntoGenericListItemModel(
      List<InventoryModel> inList) {
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
