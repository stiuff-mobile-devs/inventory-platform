class EntityModel {
  final String id;
  final String organizationId;
  final String name;
  final String type;
  final Map<String, dynamic>? attributes;
  final DateTime? createdAt;

  EntityModel({
    required this.id,
    required this.organizationId,
    required this.name,
    required this.type,
    this.attributes,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory EntityModel.fromJson(Map<String, dynamic> json) {
    return EntityModel(
      id: json['id'],
      organizationId: json['organizationId'],
      name: json['name'],
      type: json['type'],
      attributes: json['attributes'] != null
          ? Map<String, dynamic>.from(json['attributes'])
          : null,
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'organizationId': organizationId,
        'name': name,
        'type': type,
        'attributes': attributes,
        'createdAt': createdAt?.toIso8601String(),
      };
}
