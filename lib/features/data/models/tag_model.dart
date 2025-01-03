class TagModel {
  final String id;
  final String serial;
  final DateTime lastSeen;
  final DateTime createdAt;
  final String materialId;
  final String organizationId;

  TagModel(
      {required this.id,
      required this.serial,
      required this.lastSeen,
      required this.createdAt,
      required this.materialId,
      required this.organizationId})
      : assert(id.length == 24, 'ID must have exactly 24 characters.');

  factory TagModel.fromJson(Map<String, dynamic> json) {
    return TagModel(
      id: json['id'],
      serial: json['serial'],
      lastSeen: DateTime.parse(json['lastSeen']),
      createdAt: DateTime.parse(json['createdAt']),
      materialId: json['materialId'],
      organizationId: json['organizationId'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'serial': serial,
        'lastSeen': lastSeen.toIso8601String(),
        'createdAt': createdAt.toIso8601String(),
        'materialId': materialId,
        'organizationId': organizationId,
      };
}
