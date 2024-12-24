class DomainModel {
  final String id;
  final String organizationId;

  final String name;
  final String categoryId;
  final String status;
  final String? description;
  final String? location;
  final int? capacity;
  final String? ownerId;
  final DateTime? createdAt;
  final DateTime? lastUpdatedAt;
  final Map<String, dynamic>? attributes;

  DomainModel({
    required this.id,
    required this.organizationId,
    required this.name,
    required this.categoryId,
    required this.status,
    this.description,
    this.location,
    this.capacity,
    this.ownerId,
    DateTime? createdAt,
    DateTime? lastUpdatedAt,
    this.attributes,
  })  : createdAt = createdAt ?? DateTime.now(),
        lastUpdatedAt = lastUpdatedAt ?? DateTime.now();

  factory DomainModel.fromJson(Map<String, dynamic> json) {
    return DomainModel(
      id: json['id'],
      organizationId: json['organizationId'],
      name: json['name'],
      categoryId: json['category'],
      status: json['status'],
      description: json['description'],
      location: json['location'],
      capacity: json['capacity'],
      ownerId: json['ownerId'],
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      lastUpdatedAt: json['lastUpdatedAt'] != null
          ? DateTime.parse(json['lastUpdatedAt'])
          : null,
      attributes: json['attributes'] != null
          ? Map<String, dynamic>.from(json['attributes'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'organizationId': organizationId,
        'name': name,
        'category': categoryId,
        'status': status,
        'description': description,
        'location': location,
        'capacity': capacity,
        'ownerId': ownerId,
        'createdAt': createdAt?.toIso8601String(),
        'lastUpdatedAt': lastUpdatedAt?.toIso8601String(),
        'attributes': attributes,
      };
}
