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

  factory EntityModel.fromJson(Map<String, dynamic> json) {
    return EntityModel(
      id: json['id'],
      title: json['name'],
      type: json['type'],
      attributes: Map<String, dynamic>.from(json['attributes']),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': title,
        'type': type,
        'attributes': attributes,
        'createdAt': createdAt?.toIso8601String(),
      };
}
