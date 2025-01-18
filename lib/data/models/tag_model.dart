import 'package:inventory_platform/data/models/generic_list_item_model.dart';

class TagModel {
  final String id;
  final String serial;
  final int isActive;
  final DateTime? createdAt;
  final DateTime? lastSeen;

  TagModel({
    required this.id,
    required this.serial,
    required this.isActive,
    required this.lastSeen,
    required this.createdAt,
  }) : assert(id.length == 24, 'ID must have exactly 24 characters.');

  factory TagModel.fromJson(Map<String, dynamic> json) {
    return TagModel(
      id: json['id'],
      serial: json['serial'],
      isActive: json['isActive'],
      lastSeen: DateTime.parse(json['lastSeen']),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'serial': serial,
        'isActive': isActive,
        'lastSeen': lastSeen?.toIso8601String(),
        'createdAt': createdAt?.toIso8601String(),
      };

  static List<GenericListItemModel> turnIntoGenericListItemModel(
      List<TagModel> inList) {
    return inList.map((originalItem) {
      final thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30));
      final lastSeen = originalItem.lastSeen ?? DateTime.now();
      final isActive = lastSeen.isAfter(thirtyDaysAgo) ? 1 : 0;
      return GenericListItemModel(
        id: originalItem.id,
        upperHeaderField: originalItem.serial,
        lowerHeaderField: originalItem.id,
        isActive: isActive,
        initialDate: originalItem.createdAt,
        lastUpdatedAt: originalItem.lastSeen,
      );
    }).toList();
  }
}
