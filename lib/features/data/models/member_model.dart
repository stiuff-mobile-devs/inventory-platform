import 'package:inventory_platform/features/data/models/generic_list_item_model.dart';

class MemberModel {
  final String id;
  final String name;
  final String? email;
  final String role;
  final int isActive;
  final DateTime? createdAt;
  final DateTime? lastUpdatedAt;

  MemberModel({
    required this.id,
    required this.name,
    this.email,
    required this.role,
    required this.isActive,
    this.createdAt,
    this.lastUpdatedAt,
  });

  factory MemberModel.fromJson(Map<String, dynamic> json) {
    return MemberModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      role: json['role'],
      isActive: json['isActive'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'role': role,
        'isActive': isActive,
        'createdAt': createdAt?.toIso8601String(),
        'lastUpdatedAt': lastUpdatedAt?.toIso8601String(),
      };

  static List<GenericListItemModel> turnAllIntoGenericListItemModel(
      List<MemberModel> inList) {
    return inList.map((originalItem) {
      return GenericListItemModel(
        id: originalItem.email,
        upperHeaderField: originalItem.name,
        lowerHeaderField: originalItem.email,
        isActive: originalItem.isActive,
        initialDate: originalItem.createdAt,
        finalDate: originalItem.createdAt,
        lastUpdatedAt: originalItem.createdAt,
      );
    }).toList();
  }
}
