class GenericListItemModel {
  final String? id;
  final String upperHeaderField;
  final String lowerHeaderField;
  final String status;
  final DateTime? initialDate;
  final DateTime? finalDate;
  final DateTime? lastUpdatedAt;

  GenericListItemModel({
    this.id,
    required this.upperHeaderField,
    required this.lowerHeaderField,
    required this.status,
    this.initialDate,
    this.finalDate,
    DateTime? lastUpdatedAt,
  }) : lastUpdatedAt = lastUpdatedAt ?? DateTime.now();
}
