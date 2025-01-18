class Material {
  final String id;
  final String title;
  final int isActive;
  final String? tag;
  final List<String>? images;
  final String? location;
  final int? quantity;
  final String? unit;
  final String? notes;
  final Map<String, dynamic>? attributes;
  final DateTime? createdAt;
  final DateTime? lastUpdatedAt;

  Material({
    required this.id,
    required this.title,
    required this.isActive,
    this.tag,
    this.images,
    this.location,
    this.quantity,
    this.unit,
    this.notes,
    DateTime? createdAt,
    DateTime? lastUpdatedAt,
    this.attributes,
  })  : createdAt = createdAt ?? DateTime.now(),
        lastUpdatedAt = lastUpdatedAt ?? DateTime.now();

  factory Material.fromJson(Map<String, dynamic> json) {
    return Material(
      id: json['id'],
      title: json['title'],
      tag: json['tag'],
      isActive: json['isActive'],
      images: List<String>.from(json['images']),
      location: json['location'],
      quantity: json['quantity'],
      unit: json['unit'],
      createdAt: DateTime.parse(json['createdAt']),
      lastUpdatedAt: DateTime.parse(json['lastUpdatedAt']),
      notes: json['notes'],
      attributes: Map<String, dynamic>.from(json['attributes']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'tag': tag,
        'images': images,
        'location': location,
        'quantity': quantity,
        'unit': unit,
        'isActive': isActive,
        'createdAt': createdAt?.toIso8601String(),
        'lastUpdatedAt': lastUpdatedAt?.toIso8601String(),
        'notes': notes,
        'attributes': attributes,
      };
}
