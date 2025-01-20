import 'package:inventory_platform/data/models/generic_list_item_model.dart';

class InventoryModel {
  String _id;
  String _title;
  String? _description;
  String _revisionNumber;
  int _isActive;
  DateTime? _createdAt;
  DateTime? _lastUpdatedAt;

  InventoryModel({
    required String id,
    required String title,
    String? description,
    DateTime? createdAt,
    DateTime? lastUpdatedAt,
    required String revisionNumber,
    required int isActive,
  })  : _id = id,
        _title = title,
        _description = description,
        _createdAt = createdAt,
        _lastUpdatedAt = lastUpdatedAt ?? DateTime.now(),
        _revisionNumber = revisionNumber,
        _isActive = isActive;

  String get id => _id;
  String get title => _title;
  String? get description => _description;
  String get revisionNumber => _revisionNumber;
  int get isActive => _isActive;
  DateTime? get createdAt => _createdAt;
  DateTime? get lastUpdatedAt => _lastUpdatedAt;

  set id(String id) => _id = id;
  set title(String title) => _title = title;
  set description(String? description) => _description = description;
  set revisionNumber(String revisionNumber) => _revisionNumber = revisionNumber;
  set isActive(int isActive) => _isActive = isActive;
  set createdAt(DateTime? createdAt) => _createdAt = createdAt;
  set lastUpdatedAt(DateTime? lastUpdatedAt) => _lastUpdatedAt = lastUpdatedAt;

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
