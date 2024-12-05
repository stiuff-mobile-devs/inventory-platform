import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/counter_bloc.dart';
import '../bloc/counter_event.dart';
import '../bloc/counter_state.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // const Text(
            //   'Global Counter:',
            // ),
            // BlocBuilder<CounterBloc, CounterState>(
            //   builder: (context, state) {
            //     return Text(
            //       '${state.count}',
            //       style: Theme.of(context).textTheme.headlineMedium,
            //     );
            //   },
            // ),
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
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     context.read<CounterBloc>().add(IncrementCounter());
      //   },
      //   tooltip: 'Increment Global',
      //   child: const Icon(Icons.add),
      // ),
    );
  }
}
