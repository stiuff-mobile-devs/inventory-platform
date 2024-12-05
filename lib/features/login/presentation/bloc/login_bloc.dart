import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/usecases/sign_in_with_google.dart';

abstract class LoginEvent {}

class GoogleSignInRequested extends LoginEvent {}

abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final User user;
  LoginSuccess(this.user);
}

class LoginFailure extends LoginState {
  final String message;
  LoginFailure(this.message);
}

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final SignInWithGoogle signInWithGoogle;

  LoginBloc(this.signInWithGoogle) : super(LoginInitial()) {
    on<GoogleSignInRequested>((event, emit) async {
      emit(LoginLoading());
      try {
        final user = await signInWithGoogle();
        if (user != null) {
          emit(LoginSuccess(user));
        } else {
          emit(LoginFailure('Sign-In canceled'));
        }
      } catch (e) {
        emit(LoginFailure(e.toString()));
      }
    });
  }
}
