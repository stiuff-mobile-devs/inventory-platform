class ReaderModel {
  final String name;
  final String organizationId;

  final String mac;
  final String status;
  final DateTime lastSeen;

  ReaderModel({
    required this.name,
    required this.organizationId,
    required this.mac,
    required this.status,
    required this.lastSeen,
  });

  factory ReaderModel.fromJson(Map<String, dynamic> json) {
    return ReaderModel(
      name: json['name'],
      organizationId: json['organizationId'],
      mac: json['mac'],
      status: json['status'],
      lastSeen: DateTime.parse(json['lastSeen']),
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'organizationId': organizationId,
        'mac': mac,
        'status': status,
        'lastSeen': lastSeen.toIso8601String(),
      };
}
