import 'package:go_router/go_router.dart';
import 'package:inventory_platform/core/injection_container.dart';
import 'package:inventory_platform/features/home/presentation/pages/home_page.dart';
import 'package:inventory_platform/features/login/presentation/pages/login_page.dart';
import 'package:inventory_platform/routes/route_transitions.dart';

class AppRoutes {
  static final GoRouter router = GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => LoginPage(
          signInWithGoogle: sl(),
        ),
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: LoginPage(signInWithGoogle: sl()),
          transitionsBuilder: RouteTransitions.noTransition,
        ),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomePage(),
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const HomePage(),
          transitionsBuilder: RouteTransitions.noTransition,
        ),
      ),
    ],
  );
}
