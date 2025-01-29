import 'package:get/get.dart';
import 'package:inventory_platform/features/modules/form/form_binding.dart';
import 'package:inventory_platform/features/modules/form/form_page.dart';
import 'package:inventory_platform/features/modules/home/home_binding.dart';
import 'package:inventory_platform/features/modules/help/help_page.dart';
import 'package:inventory_platform/features/modules/home/home_page.dart';
import 'package:inventory_platform/features/modules/login/login_binding.dart';
import 'package:inventory_platform/features/modules/login/login_page.dart';
import 'package:inventory_platform/features/modules/panel/panel_binding.dart';
import 'package:inventory_platform/features/modules/panel/panel_page.dart';
import 'package:inventory_platform/features/modules/settings/settings_page.dart';
import 'package:inventory_platform/routes/routes.dart';

abstract class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginPage(),
      bindings: [
        LoginBinding(),
      ],
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => HomePage(),
      bindings: [
        HomeBinding(),
      ],
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.settings,
      page: () => const SettingsPage(),
      bindings: const [],
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.help,
      page: () => const HelpPage(),
      bindings: const [],
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.panel,
      page: () => const PanelPage(),
      bindings: [
        PanelBinding(),
      ],
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.form,
      page: () => FormPage(),
      bindings: [
        FormBinding(),
      ],
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 300),
    ),
  ];
}
