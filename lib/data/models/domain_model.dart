import 'package:inventory_platform/data/models/generic_list_item_model.dart';

class DomainModel {
  String _id;
  String _title;
  int _isActive;
  String? _description;
  String? _location;
  int? _capacity;
  DateTime? _createdAt;
  DateTime? _lastUpdatedAt;
  Map<String, dynamic>? _attributes;

  DomainModel({
    required String id,
    required String title,
    required int isActive,
    String? description,
    String? location,
    int? capacity,
    DateTime? createdAt,
    DateTime? lastUpdatedAt,
    Map<String, dynamic>? attributes,
  })  : _id = id,
        _title = title,
        _isActive = isActive,
        _description = description,
        _location = location,
        _capacity = capacity,
        _createdAt = createdAt ?? DateTime.now(),
        _lastUpdatedAt = lastUpdatedAt ?? DateTime.now(),
        _attributes = attributes;

  String get id => _id;
  String get title => _title;
  int get isActive => _isActive;
  String? get description => _description;
  String? get location => _location;
  int? get capacity => _capacity;
  DateTime? get createdAt => _createdAt;
  DateTime? get lastUpdatedAt => _lastUpdatedAt;
  Map<String, dynamic>? get attributes => _attributes;

  set id(String id) => _id = id;
  set title(String title) => _title = title;
  set isActive(int isActive) => _isActive = isActive;
  set description(String? description) => _description = description;
  set location(String? location) => _location = location;
  set capacity(int? capacity) => _capacity = capacity;
  set createdAt(DateTime? createdAt) => _createdAt = createdAt;
  set lastUpdatedAt(DateTime? lastUpdatedAt) => _lastUpdatedAt = lastUpdatedAt;
  set attributes(Map<String, dynamic>? attributes) => _attributes = attributes;

  factory DomainModel.fromJson(Map<String, dynamic> json) {
    return DomainModel(
        id: json['id'],
        title: json['title'],
        isActive: json['isActive'],
        description: json['description'],
        location: json['location'],
        capacity: json['capacity'],
        createdAt: DateTime.parse(json['createdAt']),
        lastUpdatedAt: DateTime.parse(json['lastUpdatedAt']),
        attributes: Map<String, dynamic>.from(json['attributes']));
  }

  Map<String, dynamic> toJson() => {
        'id': _id,
        'title': _title,
        'status': _isActive,
        'description': _description,
        'location': _location,
        'capacity': _capacity,
        'createdAt': _createdAt?.toIso8601String(),
        'lastUpdatedAt': _lastUpdatedAt?.toIso8601String(),
        'attributes': _attributes,
      };

  static List<GenericListItemModel> turnAllIntoGenericListItemModel(
      List<DomainModel> inList) {
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
