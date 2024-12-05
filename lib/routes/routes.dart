import 'package:flutter/material.dart';
import 'package:inventory_platform/features/login/presentation/pages/login_page.dart';

class AppRoutes {
  static const String login = '/login';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(
          builder: (_) => const LoginPage(
            title: 'Login Page',
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const LoginPage(
            title: 'Page Not Found',
          ),
        );
    }
  }
}
