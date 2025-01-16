class AuthWarning implements Exception {
  final String message;
  AuthWarning(this.message);
}

class SignInInterruptionWarning extends AuthWarning {
  SignInInterruptionWarning() : super("O login foi cancelado pelo usuário.");
}
