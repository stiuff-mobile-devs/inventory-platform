import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:inventory_platform/core/theme/app_theme.dart';
import 'package:inventory_platform/features/data/services/auth_service.dart';
import 'package:inventory_platform/firebase_options.dart';
import 'package:inventory_platform/routes/pages.dart';
import 'package:inventory_platform/routes/routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  Get.put(AuthService());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Inventário Universal',
      initialRoute: AppRoutes.login,
      theme: globalTheme,
      getPages: AppPages.pages,
    );
  }
}
