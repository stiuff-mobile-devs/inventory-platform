import 'package:inventory_platform/data/models/user_model.dart';
import 'package:uuid/uuid.dart';

class UserRepository {
  final List<UserModel> _users = [];

  List<UserModel> getAllUsers() {
    return _users;
  }

  UserModel? getUserById(String id) {
    return _users.firstWhere((user) => user.id == id);
  }

  void addUser(UserModel user) {
    _users.add(user);
  }

  void updateUser(UserModel updatedUser) {
    final index = _users.indexWhere((user) => user.id == updatedUser.id);
    if (index != -1) {
      _users[index] = updatedUser;
    }
  }

  void deleteUser(String id) {
    _users.removeWhere((user) => user.id == id);
  }

  String generateUniqueId() {
    var uuid = const Uuid();
    String id;
    do {
      id = uuid.v4();
    } while (_users.any((tag) => tag.id == id));
    return id;
  }
}
