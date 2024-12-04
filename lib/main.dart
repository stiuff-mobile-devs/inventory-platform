import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_platform/features/theme/domain/usecases/toggle_theme_usecase.dart';
import 'package:inventory_platform/features/theme/presentation/bloc/theme_bloc.dart';
import 'package:inventory_platform/features/theme/presentation/screens/my_home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPreferences = await SharedPreferences.getInstance();
  runApp(
    MultiProvider(
      providers: [
        BlocProvider<ThemeBloc>(
          create: (context) => ThemeBloc(
            toggleThemeUseCase: ToggleThemeUseCase(),
          ),
        ),
      ],
      child: MyApp(sharedPreferences: sharedPreferences),
    ),
  );
}

class MyApp extends StatelessWidget {
  final SharedPreferences sharedPreferences;

  const MyApp({super.key, required this.sharedPreferences});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Inventory Platform',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: context.select((ThemeBloc bloc) {
        if (bloc.state is ThemeChanged) {
          return (bloc.state as ThemeChanged).isDarkTheme
              ? ThemeMode.dark
              : ThemeMode.light;
        } else {
          return ThemeMode.light;
        }
      }),
      home: const MyHomePage(),
    );
  }
}
