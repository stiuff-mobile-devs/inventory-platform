import 'package:get/get.dart';
import 'package:inventory_platform/features/modules/home/home_binding.dart';
import 'package:inventory_platform/features/modules/help/help_page.dart';
import 'package:inventory_platform/features/modules/home/home_page.dart';
import 'package:inventory_platform/features/modules/login/login_binding.dart';
import 'package:inventory_platform/features/modules/login/login_page.dart';
import 'package:inventory_platform/features/modules/settings/settings_page.dart';
import 'package:inventory_platform/routes/routes.dart';

abstract class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginPage(),
      binding: LoginBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 200),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomePage(),
      binding: HomeBinding(),
      transition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 200),
    ),
    GetPage(
      name: AppRoutes.settings,
      page: () => const SettingsPage(),
      transition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 200),
    ),
    GetPage(
      name: AppRoutes.help,
      page: () => const HelpPage(),
      transition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 200),
    ),
  ];
}
