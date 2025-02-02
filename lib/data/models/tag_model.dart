class TagModel {
  String _id;
  int _isActive;
  DateTime? _createdAt;
  DateTime? _lastSeen;

  TagModel({
    required String id,
    required int isActive,
    required DateTime? lastSeen,
    required DateTime? createdAt,
  })  : _id = id,
        _isActive = isActive,
        _lastSeen = lastSeen,
        _createdAt = createdAt {
    assert(id.length == 24, 'ID must have exactly 24 characters.');
  }

  String get id => _id;
  set id(String id) {
    assert(id.length == 24, 'ID must have exactly 24 characters.');
    _id = id;
  }

  int get isActive => _isActive;
  DateTime? get createdAt => _createdAt;
  DateTime? get lastSeen => _lastSeen;

  set isActive(int isActive) => _isActive = isActive;
  set createdAt(DateTime? createdAt) => _createdAt = createdAt;
  set lastSeen(DateTime? lastSeen) => _lastSeen = lastSeen;

  factory TagModel.fromMap(Map<String, dynamic> map) {
    return TagModel(
      id: map['id'],
      isActive: map['isActive'],
      lastSeen:
          map['lastSeen'] != null ? DateTime.parse(map['lastSeen']) : null,
      createdAt:
          map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': _id,
        'isActive': _isActive,
        'lastSeen': _lastSeen?.toIso8601String(),
        'createdAt': _createdAt?.toIso8601String(),
      };
}
