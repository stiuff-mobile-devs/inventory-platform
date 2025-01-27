class UserModel {
  String _id;
  String _name;
  String _email;
  String? _profileImageUrl;

  UserModel({
    required String id,
    required String name,
    required String email,
    String? profileImageUrl,
  })  : _id = id,
        _name = name,
        _email = email,
        _profileImageUrl = profileImageUrl;

  String get id => _id;
  String get name => _name;
  String get email => _email;
  String? get profileImageUrl => _profileImageUrl;

  set id(String id) => _id = id;
  set name(String name) => _name = name;
  set email(String email) => _email = email;
  set profileImageUrl(String? profileImageUrl) =>
      _profileImageUrl = profileImageUrl;

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      profileImageUrl: map['profileImageUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': _id,
      'name': _name,
      'email': _email,
      'profileImageUrl': _profileImageUrl,
    };
  }
}
