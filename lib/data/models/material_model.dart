class Material {
  String _id;
  String _title;
  int _isActive;
  String? _tag;
  List<String>? _images;
  String? _location;
  int? _quantity;
  String? _unit;
  String? _notes;
  Map<String, dynamic>? _attributes;
  DateTime? _createdAt;
  DateTime? _lastUpdatedAt;

  Material({
    required String id,
    required String title,
    required int isActive,
    String? tag,
    List<String>? images,
    String? location,
    int? quantity,
    String? unit,
    String? notes,
    DateTime? createdAt,
    DateTime? lastUpdatedAt,
    Map<String, dynamic>? attributes,
  })  : _id = id,
        _title = title,
        _isActive = isActive,
        _tag = tag,
        _images = images,
        _location = location,
        _quantity = quantity,
        _unit = unit,
        _notes = notes,
        _createdAt = createdAt ?? DateTime.now(),
        _lastUpdatedAt = lastUpdatedAt ?? DateTime.now(),
        _attributes = attributes;

  String get id => _id;
  String get title => _title;
  int get isActive => _isActive;
  String? get tag => _tag;
  List<String>? get images => _images;
  String? get location => _location;
  int? get quantity => _quantity;
  String? get unit => _unit;
  String? get notes => _notes;
  Map<String, dynamic>? get attributes => _attributes;
  DateTime? get createdAt => _createdAt;
  DateTime? get lastUpdatedAt => _lastUpdatedAt;

  set id(String id) => _id = id;
  set title(String title) => _title = title;
  set isActive(int isActive) => _isActive = isActive;
  set tag(String? tag) => _tag = tag;
  set images(List<String>? images) => _images = images;
  set location(String? location) => _location = location;
  set quantity(int? quantity) => _quantity = quantity;
  set unit(String? unit) => _unit = unit;
  set notes(String? notes) => _notes = notes;
  set attributes(Map<String, dynamic>? attributes) => _attributes = attributes;
  set createdAt(DateTime? createdAt) => _createdAt = createdAt;
  set lastUpdatedAt(DateTime? lastUpdatedAt) => _lastUpdatedAt = lastUpdatedAt;

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
