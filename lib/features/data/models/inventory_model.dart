class InventoryModel {
  final String id;
  final String title;
  final String description;
  final String organizationId;
  final DateTime? openedAt;
  final DateTime? closedAt;
  final DateTime? lastUpdatedAt;
  final int revisionNumber;
  final String status;

  InventoryModel({
    required this.id,
    required this.title,
    required this.description,
    required this.organizationId,
    this.openedAt,
    this.closedAt,
    DateTime? lastUpdatedAt,
    required this.revisionNumber,
    required this.status,
  }) : lastUpdatedAt = lastUpdatedAt ?? DateTime.now();

  factory InventoryModel.fromJson(Map<String, dynamic> json) {
    return InventoryModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      organizationId: json['organizationId'],
      openedAt:
          json['openedAt'] != null ? DateTime.parse(json['openedAt']) : null,
      closedAt:
          json['closedAt'] != null ? DateTime.parse(json['closedAt']) : null,
      lastUpdatedAt: json['lastUpdatedAt'] != null
          ? DateTime.parse(json['lastUpdatedAt'])
          : null,
      revisionNumber: json['revisionNumber'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'organizationId': organizationId,
        'openedAt': openedAt?.toIso8601String(),
        'closedAt': closedAt?.toIso8601String(),
        'lastUpdatedAt': lastUpdatedAt?.toIso8601String(),
        'revisionNumber': revisionNumber,
        'status': status,
      };
}
