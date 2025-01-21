import 'package:inventory_platform/data/models/generic_list_item_model.dart';

class ReaderModel {
  String _name;
  String _mac;
  int _isActive;
  DateTime? _createdAt;
  DateTime? _lastSeen;

  ReaderModel({
    required String name,
    required String mac,
    required int isActive,
    DateTime? createdAt,
    DateTime? lastSeen,
  })  : _name = name,
        _mac = mac,
        _isActive = isActive,
        _createdAt = createdAt,
        _lastSeen = lastSeen;

  String get name => _name;
  String get mac => _mac;
  int get isActive => _isActive;
  DateTime? get createdAt => _createdAt;
  DateTime? get lastSeen => _lastSeen;

  set name(String name) => _name = name;
  set mac(String mac) => _mac = mac;
  set isActive(int isActive) => _isActive = isActive;
  set createdAt(DateTime? createdAt) => _createdAt = createdAt;
  set lastSeen(DateTime? lastSeen) => _lastSeen = lastSeen;

  factory ReaderModel.fromMap(Map<String, dynamic> map) {
    return ReaderModel(
      name: map['name'],
      mac: map['mac'],
      isActive: map['isActive'],
      createdAt: DateTime.parse(map['createdAt']),
      lastSeen: DateTime.parse(map['lastSeen']),
    );
  }

  Map<String, dynamic> toMap() => {
        'name': _name,
        'mac': _mac,
        'isActive': _isActive,
        'createdAt': _createdAt?.toIso8601String(),
        'lastSeen': _lastSeen?.toIso8601String(),
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
