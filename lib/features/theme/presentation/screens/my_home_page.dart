import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_platform/features/theme/presentation/bloc/theme_bloc.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inventory Platform')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            context.read<ThemeBloc>().add(ToggleThemeEvent());
          },
          child: const Text('Toggle Theme'),
        ),
      ),
    );
  }
}
