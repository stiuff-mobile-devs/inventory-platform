import 'package:inventory_platform/data/models/generic_list_item_model.dart';

class TagModel {
  String _id;
  String _serial;
  int _isActive;
  DateTime? _createdAt;
  DateTime? _lastSeen;

  TagModel({
    required String id,
    required String serial,
    required int isActive,
    required DateTime? lastSeen,
    required DateTime? createdAt,
  })  : _id = id,
        _serial = serial,
        _isActive = isActive,
        _lastSeen = lastSeen,
        _createdAt = createdAt {
    assert(id.length == 24, 'ID must have exactly 24 characters.');
  }

  String get id => _id;
  set id(String id) {
    assert(id.length == 24, 'ID must have exactly 24 characters.');
    _id = id;
  }

  String get serial => _serial;
  int get isActive => _isActive;
  DateTime? get createdAt => _createdAt;
  DateTime? get lastSeen => _lastSeen;

  set isActive(int isActive) => _isActive = isActive;
  set serial(String serial) => _serial = serial;
  set createdAt(DateTime? createdAt) => _createdAt = createdAt;
  set lastSeen(DateTime? lastSeen) => _lastSeen = lastSeen;

  factory TagModel.fromMap(Map<String, dynamic> map) {
    return TagModel(
      id: map['id'],
      serial: map['serial'],
      isActive: map['isActive'],
      lastSeen: DateTime.parse(map['lastSeen']),
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  Map<String, dynamic> toMap() => {
        'id': _id,
        'serial': _serial,
        'isActive': _isActive,
        'lastSeen': _lastSeen?.toIso8601String(),
        'createdAt': _createdAt?.toIso8601String(),
      };

  static List<GenericListItemModel> turnAllIntoGenericListItemModel(
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
