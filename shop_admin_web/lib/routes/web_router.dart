import 'package:go_router/go_router.dart';

import '../presentation/screens/admin_dashboard_screen.dart';
import '../presentation/screens/login_screen.dart';

class WebRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const AdminDashboardScreen(),
      ),
    ],
  );
}
