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

  factory InventoryModel.fromMap(Map<String, dynamic> map) {
    return InventoryModel(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      revisionNumber: map['revisionNumber'],
      isActive: map['isActive'],
      createdAt:
          map['openedAt'] != null ? DateTime.parse(map['openedAt']) : null,
      lastUpdatedAt: map['lastUpdatedAt'] != null
          ? DateTime.parse(map['lastUpdatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'isActive': isActive,
        'description': description,
        'openedAt': createdAt?.toIso8601String(),
        'lastUpdatedAt': lastUpdatedAt?.toIso8601String(),
        'revisionNumber': revisionNumber,
      };
}
