class OrganizationModel {
  final String title;
  final String description;
  final String? imagePath;

  final String id;

  OrganizationModel({
    required this.title,
    required this.description,
    this.imagePath,
    required this.id,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'imagePath': imagePath,
      'id': id,
    };
  }

  factory OrganizationModel.fromJson(Map<String, dynamic> json) {
    return OrganizationModel(
      title: json['title'] as String,
      description: json['description'] as String,
      imagePath: json['imagePath'] as String,
      id: json['id'] as String,
    );
  }
}
