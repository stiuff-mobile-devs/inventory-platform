// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:inventory_platform/core/bindings.dart';
import 'package:inventory_platform/core/theme/app_theme.dart';
import 'package:inventory_platform/core/services/auth_service.dart';
import 'package:inventory_platform/data/database/database_helper.dart';
import 'package:inventory_platform/firebase_options.dart';
import 'package:inventory_platform/routes/pages.dart';
import 'package:inventory_platform/routes/routes.dart';
import 'package:inventory_platform/core/debug/debug_overlay.dart';
import 'package:inventory_platform/core/debug/logger.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize logger early
  Logger.init();

  dotenv.load(fileName: ".env");

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e, stackTrace) {
    if (e.toString().contains('duplicate-app')) {
      // Firebase already initialized, continue
      Logger.info('Firebase already initialized');
    } else {
      // Handle other potential errors
      Logger.error('Error initializing Firebase: $e', stackTrace);
      rethrow;
    }
  }

  CoreBindings().dependencies();

  final AuthService authService = Get.find();
  final initialRoute =
      authService.isUserLoggedIn ? AppRoutes.home : AppRoutes.login;

  // Initialize DB in background, don't await it here
  final dbHelper = Get.find<DatabaseHelper>();
  dbHelper.database.then((_) {
    // DB is ready, but we don't need to block the UI for it
  });

  // Run app in a custom Zone that captures stdout (print statements)
  runApp(
      // Only wrap with DebugOverlay in debug mode
      kDebugMode
          ? DebugOverlay(child: MyApp(initialRoute: initialRoute))
          : MyApp(initialRoute: initialRoute));
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
