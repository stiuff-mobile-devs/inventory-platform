class MemberModel {
  final String id;
  final String name;
  final String email;
  final String role;
  final String status;
  final DateTime createdAt;
  final List<String> organizations;

  MemberModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.status,
    required this.createdAt,
    required this.organizations,
  });

  factory MemberModel.fromJson(Map<String, dynamic> json) {
    return MemberModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      role: json['role'],
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']),
      organizations: List<String>.from(json['organizations'] ?? []),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'role': role,
        'status': status,
        'createdAt': createdAt.toIso8601String(),
        'organizations': organizations,
      };
}
