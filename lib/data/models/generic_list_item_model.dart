class GenericListItemModel {
  final String? id;
  final String upperHeaderField;
  final String? lowerHeaderField;
  final int isActive;
  final DateTime? initialDate;
  final DateTime? lastUpdatedAt;

  GenericListItemModel({
    this.id,
    required this.upperHeaderField,
    required this.lowerHeaderField,
    required this.isActive,
    this.initialDate,
    this.lastUpdatedAt,
  });
}
