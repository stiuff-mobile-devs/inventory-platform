import 'package:get/get.dart';
import 'package:inventory_platform/core/bindings.dart';
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
      bindings: [
        CoreBindings(),
        LoginBinding(),
      ],
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomePage(),
      bindings: [
        CoreBindings(),
        HomeBinding(),
      ],
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.settings,
      page: () => const SettingsPage(),
      bindings: [
        CoreBindings(),
      ],
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.help,
      page: () => const HelpPage(),
      bindings: [
        CoreBindings(),
      ],
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 300),
    ),
  ];
}
