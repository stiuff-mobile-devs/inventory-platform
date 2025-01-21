import 'package:inventory_platform/data/models/generic_list_item_model.dart';
import 'package:inventory_platform/data/models/user_model.dart';

class MemberModel {
  String _id;
  UserModel _user;
  String _role;
  int _isActive;
  DateTime? _createdAt;
  DateTime? _lastSeen;

  MemberModel({
    required String id,
    required UserModel user,
    required String role,
    required int isActive,
    DateTime? createdAt,
    DateTime? lastSeen,
  })  : _id = id,
        _user = user,
        _role = role,
        _isActive = isActive,
        _createdAt = createdAt,
        _lastSeen = lastSeen;

  String get id => _id;
  UserModel get user => _user;
  String get role => _role;
  int get isActive => _isActive;
  DateTime? get createdAt => _createdAt;
  DateTime? get lastSeen => _lastSeen;

  set id(String id) => _id = id;
  set user(UserModel user) => _user = user;
  set role(String role) => _role = role;
  set isActive(int isActive) => _isActive = isActive;
  set createdAt(DateTime? createdAt) => _createdAt = createdAt;
  set lastSeen(DateTime? lastSeen) => _lastSeen = lastSeen;

  factory MemberModel.fromMap(Map<String, dynamic> map) {
    return MemberModel(
      id: map['id'],
      user: UserModel.fromMap(map['user']),
      role: map['role'],
      isActive: map['isActive'],
      createdAt: DateTime.parse(map['createdAt']),
      lastSeen:
          map['lastSeen'] != null ? DateTime.parse(map['lastSeen']) : null,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': _id,
        'user': _user.toMap(),
        'role': _role,
        'isActive': _isActive,
        'createdAt': _createdAt?.toIso8601String(),
        'lastSeen': _lastSeen?.toIso8601String(),
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
