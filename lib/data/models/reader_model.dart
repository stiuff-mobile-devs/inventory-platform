import 'package:inventory_platform/data/models/generic_list_item_model.dart';

class ReaderModel {
  final String name;
  final String mac;
  final int isActive;
  final DateTime? createdAt;
  final DateTime? lastSeen;

  ReaderModel({
    required this.name,
    required this.mac,
    required this.isActive,
    this.createdAt,
    this.lastSeen,
  });

  factory ReaderModel.fromJson(Map<String, dynamic> json) {
    return ReaderModel(
      name: json['name'],
      mac: json['mac'],
      isActive: json['isActive'],
      createdAt: DateTime.parse(json['createdAt']),
      lastSeen: DateTime.parse(json['lastSeen']),
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'mac': mac,
        'isActive': isActive,
        'createdAt': createdAt?.toIso8601String(),
        'lastSeen': lastSeen?.toIso8601String(),
      };

  static List<GenericListItemModel> turnAllIntoGenericListItemModel(
      List<ReaderModel> inList) {
    return inList.map((originalItem) {
      return GenericListItemModel(
        id: originalItem.mac,
        upperHeaderField: originalItem.name,
        lowerHeaderField: originalItem.mac,
        isActive: originalItem.isActive,
        initialDate: originalItem.createdAt,
        lastUpdatedAt: originalItem.lastSeen,
      );
    }).toList();
  }
}
