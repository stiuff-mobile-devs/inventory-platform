import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/services/firebase_service.dart';

abstract class LoginRepository {
  Future<User?> signInWithGoogle();
}

class LoginRepositoryImpl implements LoginRepository {
  final FirebaseService firebaseService;

  LoginRepositoryImpl({required this.firebaseService});

  @override
  Future<User?> signInWithGoogle() => firebaseService.signInWithGoogle();
}
