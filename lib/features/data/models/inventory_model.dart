import 'package:inventory_platform/features/data/models/generic_list_item_model.dart';

class InventoryModel {
  final String id;
  final String title;
  final String description;
  final String organizationId;
  final int revisionNumber;
  final String status;
  final DateTime? createdAt;
  final DateTime? closedAt;
  final DateTime? lastUpdatedAt;

  InventoryModel({
    required this.id,
    required this.title,
    required this.description,
    required this.organizationId,
    this.createdAt,
    this.closedAt,
    DateTime? lastUpdatedAt,
    required this.revisionNumber,
    required this.status,
  }) : lastUpdatedAt = lastUpdatedAt ?? DateTime.now();

  factory InventoryModel.fromJson(Map<String, dynamic> json) {
    return InventoryModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      organizationId: json['organizationId'],
      createdAt:
          json['openedAt'] != null ? DateTime.parse(json['openedAt']) : null,
      closedAt:
          json['closedAt'] != null ? DateTime.parse(json['closedAt']) : null,
      lastUpdatedAt: json['lastUpdatedAt'] != null
          ? DateTime.parse(json['lastUpdatedAt'])
          : null,
      revisionNumber: json['revisionNumber'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'organizationId': organizationId,
        'openedAt': createdAt?.toIso8601String(),
        'closedAt': closedAt?.toIso8601String(),
        'lastUpdatedAt': lastUpdatedAt?.toIso8601String(),
        'revisionNumber': revisionNumber,
        'status': status,
      };

  static List<GenericListItemModel> turnIntoGenericListItemModel(
      List<InventoryModel> inList) {
    return inList.map((originalItem) {
      return GenericListItemModel(
        id: originalItem.id,
        upperHeaderField: originalItem.title,
        lowerHeaderField: originalItem.description,
        status: originalItem.status,
        initialDate: originalItem.createdAt,
        finalDate: originalItem.closedAt,
        lastUpdatedAt: originalItem.lastUpdatedAt,
      );
    }).toList();
  }
}
