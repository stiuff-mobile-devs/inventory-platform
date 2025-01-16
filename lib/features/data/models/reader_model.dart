import 'package:inventory_platform/features/data/models/generic_list_item_model.dart';

class ReaderModel {
  final String name;
  final String organizationId;

  final String mac;
  final String status;
  final DateTime lastSeen;

  ReaderModel({
    required this.name,
    required this.organizationId,
    required this.mac,
    required this.status,
    required this.lastSeen,
  });

  factory ReaderModel.fromJson(Map<String, dynamic> json) {
    return ReaderModel(
      name: json['name'],
      organizationId: json['organizationId'],
      mac: json['mac'],
      status: json['status'],
      lastSeen: DateTime.parse(json['lastSeen']),
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'organizationId': organizationId,
        'mac': mac,
        'status': status,
        'lastSeen': lastSeen.toIso8601String(),
      };

  static List<GenericListItemModel> turnIntoGenericListItemModel(
      List<ReaderModel> inList) {
    return inList.map((originalItem) {
      return GenericListItemModel(
        id: originalItem.mac,
        upperHeaderField: originalItem.name,
        lowerHeaderField: originalItem.mac,
        status: originalItem.status,
        initialDate: originalItem.lastSeen,
        finalDate: originalItem.lastSeen,
        lastUpdatedAt: originalItem.lastSeen,
      );
    }).toList();
  }
}
