class EntityModel {
  String _id;
  String _title;
  String _type;
  Map<String, dynamic>? _attributes;
  DateTime? _createdAt;

  EntityModel({
    required String id,
    required String title,
    required String type,
    Map<String, dynamic>? attributes,
    DateTime? createdAt,
  })  : _id = id,
        _title = title,
        _type = type,
        _attributes = attributes,
        _createdAt = createdAt ?? DateTime.now();

  String get id => _id;
  String get title => _title;
  String get type => _type;
  Map<String, dynamic>? get attributes => _attributes;
  DateTime? get createdAt => _createdAt;

  set id(String id) => _id = id;
  set title(String title) => _title = title;
  set type(String type) => _type = type;
  set attributes(Map<String, dynamic>? attributes) => _attributes = attributes;
  set createdAt(DateTime? createdAt) => _createdAt = createdAt;

  factory EntityModel.fromMap(Map<String, dynamic> map) {
    return EntityModel(
      id: map['id'],
      title: map['name'],
      type: map['type'],
      attributes: Map<String, dynamic>.from(map['attributes']),
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': title,
        'type': type,
        'attributes': attributes,
        'createdAt': createdAt?.toIso8601String(),
      };
}
