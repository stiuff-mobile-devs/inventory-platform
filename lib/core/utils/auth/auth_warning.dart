class AuthWarning implements Exception {
  final String message;
  AuthWarning(this.message);
}

class UserCancelledWarning extends AuthWarning {
  UserCancelledWarning() : super("O login foi cancelado pelo usuário.");
}
