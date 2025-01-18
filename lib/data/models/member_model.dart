import 'package:inventory_platform/data/models/generic_list_item_model.dart';
import 'package:inventory_platform/data/models/user_model.dart';

class MemberModel {
  final String id;
  final UserModel user;
  final String role;
  final int isActive;
  final DateTime? createdAt;
  final DateTime? lastSeen;

  MemberModel({
    required this.id,
    required this.user,
    required this.role,
    required this.isActive,
    this.createdAt,
    this.lastSeen,
  });

  factory MemberModel.fromJson(Map<String, dynamic> json) {
    return MemberModel(
      id: json['id'],
      user: UserModel.fromJson(json['user']),
      role: json['role'],
      isActive: json['isActive'],
      createdAt: DateTime.parse(json['createdAt']),
      lastSeen:
          json['lastSeen'] != null ? DateTime.parse(json['lastSeen']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'user': user.toJson(),
        'role': role,
        'isActive': isActive,
        'createdAt': createdAt?.toIso8601String(),
        'lastSeen': lastSeen?.toIso8601String(),
      };

  static List<GenericListItemModel> turnAllIntoGenericListItemModel(
      List<MemberModel> inList) {
    return inList.map((originalItem) {
      return GenericListItemModel(
        id: originalItem.user.email,
        upperHeaderField: originalItem.user.name,
        lowerHeaderField: originalItem.user.email,
        isActive: originalItem.isActive,
        initialDate: originalItem.createdAt,
        lastUpdatedAt: originalItem.createdAt,
      );
    }).toList();
  }
}
