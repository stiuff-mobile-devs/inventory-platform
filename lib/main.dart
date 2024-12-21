// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:inventory_platform/core/bindings.dart';
import 'package:inventory_platform/core/theme/app_theme.dart';
import 'package:inventory_platform/features/data/services/auth_service.dart';
import 'package:inventory_platform/firebase_options.dart';
import 'package:inventory_platform/routes/pages.dart';
import 'package:inventory_platform/routes/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Get.put(ConnectionService());
  // Get.put(ConnectionController());
  // ...
  CoreBindings().dependencies();

  final AuthService authService = Get.find();
  final initialRoute =
      authService.isUserLoggedIn ? AppRoutes.home : AppRoutes.login;

  runApp(MyApp(initialRoute: initialRoute));
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Inventário Universal',
      initialRoute: initialRoute,
      theme: globalTheme,
      getPages: AppPages.pages,
    );
  }
}
