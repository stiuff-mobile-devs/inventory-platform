import 'package:firebase_auth/firebase_auth.dart';
import 'package:inventory_platform/features/login/data/repositories/login_repository_impl.dart';

class SignInWithGoogle {
  final LoginRepository repository;

  SignInWithGoogle(this.repository);

  Future<User?> call() => repository.signInWithGoogle();
}
