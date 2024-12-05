import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/sign_in_with_google.dart';
import 'login_event.dart';
import 'login_state.dart';

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
