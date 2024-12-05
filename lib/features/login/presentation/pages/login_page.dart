import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:inventory_platform/features/login/presentation/bloc/login_bloc.dart';
import '../../domain/usecases/sign_in_with_google.dart'; // Certifique-se de importar corretamente
import '../bloc/counter_bloc.dart';
import '../bloc/counter_event.dart';
import '../bloc/counter_state.dart';

class LoginPage extends StatelessWidget {
  final SignInWithGoogle signInWithGoogle;

  const LoginPage({super.key, required this.signInWithGoogle});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(signInWithGoogle),
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 40),
              const Text(
                'Local Counter:',
              ),
              BlocProvider(
                create: (_) => CounterBloc(),
                child: BlocBuilder<CounterBloc, CounterState>(
                  builder: (localContext, localState) {
                    return Column(
                      children: [
                        Text(
                          '${localState.count}',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 20),
                        FloatingActionButton(
                          onPressed: () {
                            localContext
                                .read<CounterBloc>()
                                .add(IncrementCounter());
                          },
                          tooltip: 'Increment Local',
                          child: const Icon(Icons.add),
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 40),
              BlocConsumer<LoginBloc, LoginState>(
                listener: (context, state) {
                  if (state is LoginSuccess) {
                    context.go('/home');
                  } else if (state is LoginFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.message)),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is LoginLoading) {
                    return const CircularProgressIndicator();
                  }
                  return ElevatedButton(
                    onPressed: () {
                      context.read<LoginBloc>().add(GoogleSignInRequested());
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 30),
                      backgroundColor: Colors.deepPurple,
                      textStyle: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    child: const Text('Sign in with Google'),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
