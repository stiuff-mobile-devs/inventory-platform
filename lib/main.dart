import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_platform/core/injection_container.dart' as di;
import 'package:inventory_platform/core/services/firebase_service.dart';
// import 'package:inventory_platform/features/login/presentation/bloc/counter_bloc.dart';
import 'package:inventory_platform/routes/routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  await FirebaseInitializer.initializeFirebase();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: AppRoutes.login, // Define a rota inicial
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return MultiBlocProvider(
  //     providers: [
  //       BlocProvider(create: (_) => CounterBloc()),
  //     ],
  //     child: MaterialApp(
  //       title: 'Flutter Demo',
  //       theme: ThemeData(
  //         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
  //         useMaterial3: true,
  //       ),
  //       home: const LoginPage(title: 'Flutter Demo Login Page'),
  //     ),
  //   );
  // }
}
