class Material {
  final String id;
  final String name;
  final String tag;
  final List<String> images;
  final String location;
  final String category;
  final int quantity;
  final String unit;
  final String status; // (is / isn't) functional
  final DateTime? createdAt;
  final DateTime? lastUpdatedAt;
  final String? notes;
  final Map<String, dynamic>? attributes;

  Material({
    required this.id,
    required this.name,
    required this.tag,
    required this.images,
    required this.location,
    required this.category,
    required this.quantity,
    required this.unit,
    required this.status,
    DateTime? createdAt,
    DateTime? lastUpdatedAt,
    this.notes,
    this.attributes,
  })  : createdAt = createdAt ?? DateTime.now(),
        lastUpdatedAt = lastUpdatedAt ?? DateTime.now();

  factory Material.fromJson(Map<String, dynamic> json) {
    return Material(
      id: json['id'],
      name: json['name'],
      tag: json['tag'],
      images: List<String>.from(json['images'] ?? []),
      location: json['location'],
      category: json['category'],
      quantity: json['quantity'],
      unit: json['unit'],
      status: json['status'],
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      lastUpdatedAt: json['lastUpdatedAt'] != null
          ? DateTime.parse(json['lastUpdatedAt'])
          : null,
      notes: json['notes'],
      attributes: json['attributes'] != null
          ? Map<String, dynamic>.from(json['attributes'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'tag': tag,
        'images': images,
        'location': location,
        'category': category,
        'quantity': quantity,
        'unit': unit,
        'status': status,
        'createdAt': createdAt?.toIso8601String(),
        'lastUpdatedAt': lastUpdatedAt?.toIso8601String(),
        'notes': notes,
        'attributes': attributes,
      };
}
