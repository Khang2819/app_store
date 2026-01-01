import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../presentation/bloc/auth/auth_admin_bloc.dart';
import '../presentation/screens/admin_banner_screen.dart';
import '../presentation/screens/admin_dashboard_screen.dart';
import '../presentation/screens/admin_noti_screen.dart';
import '../presentation/screens/admin_order_screen.dart';
import '../presentation/screens/admin_products_screen.dart';
import '../presentation/screens/admin_users_screen.dart';
import '../presentation/screens/login_admin_screen.dart';

class WebRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/login',
    redirect: (BuildContext context, GoRouterState state) {
      // 1. Đọc trạng thái Auth hiện tại
      final authState = context.read<AuthAdminBloc>().state;
      final isAuthenticated = authState.isSuccess;
      final isLoggingIn = state.uri.path == '/login';

      // 3. Nếu người dùng đã đăng nhập (isAuthenticated) VÀ đang cố truy cập
      //    trang Login (isLoggingIn), hãy chuyển hướng họ đến Dashboard.
      if (isLoggingIn && isAuthenticated) {
        return '/dashboard'; // Chuyển hướng đến Dashboard
      }

      // 4. Các trường hợp khác: Trả về null để tiếp tục chuyển hướng
      //    bình thường (cho phép truy cập Login nếu chưa đăng nhập,
      //    hoặc truy cập các trang khác nếu đã đăng nhập).
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginAdminScreen(),
      ),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => AdminLayoutScreen(),
      ),
      GoRoute(path: '/users', builder: (context, state) => AdminUsersScreen()),
      GoRoute(
        path: '/products',
        builder: (context, state) => AdminProductsScreen(),
      ),
      GoRoute(path: '/orders', builder: (context, state) => AdminOrderScreen()),
      GoRoute(
        path: '/banner',
        builder: (context, state) => AdminBannerScreen(),
      ),
      GoRoute(
        path: '/notification',
        builder: (context, state) => AdminNotiScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => AdminLayoutScreen(),
      ),
    ],
  );
}
