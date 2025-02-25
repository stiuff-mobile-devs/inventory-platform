class UserCredentialsModel {
  String? _name;
  String _email;
  String? _password;

  UserCredentialsModel({
    String? name,
    required String email,
    String? password,
  })  : _name = name,
        _email = email,
        _password = password;

  String? get name => _name;
  String get email => _email;
  String? get password => _password;

  set name(String? name) => _name = name;
  set email(String email) => _email = email;
  set password(String? password) => _password = password;

  factory UserCredentialsModel.fromMap(Map<String, dynamic> map) {
    return UserCredentialsModel(
      name: map['name'],
      email: map['email'],
      password: map['password'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': _name,
      'email': _email,
      'password': _password,
    };
  }
}
