class EntityModel {
  final String id;
  final String title;
  final String type;
  final Map<String, dynamic>? attributes;
  final DateTime? createdAt;

  EntityModel({
    required this.id,
    required this.title,
    required this.type,
    this.attributes,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

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
