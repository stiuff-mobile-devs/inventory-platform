class AuthError implements Exception {
  final String message;
  AuthError(this.message);
}

class InvalidCredentialsError extends AuthError {
  InvalidCredentialsError() : super("Credenciais inválidas.");
}

class NetworkError extends AuthError {
  NetworkError() : super("Erro de rede. Verifique sua conexão.");
}
