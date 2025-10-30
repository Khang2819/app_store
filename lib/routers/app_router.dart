import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../data/models/product_model.dart';
import '../data/repositories/auth_login.dart';
import '../data/repositories/product_repository.dart';
import '../presentation/bloc/auth/auth_bloc.dart';
import '../presentation/bloc/product_detail/product_detail_bloc.dart';
import '../presentation/bloc/product_detail/product_detail_event.dart';
import '../presentation/screens/forgot_screen.dart';
import '../presentation/screens/login_screen.dart';
import '../presentation/screens/main_nav_screen.dart';
import '../presentation/screens/product_detail_screen.dart';
import '../presentation/screens/register_screen.dart';
import '../presentation/screens/slpash.dart';

class AppRouter {
  static final AuthRepository _authRepository = AuthRepository();
  static final ProductRepository _productRepository = ProductRepository();

  static final GoRouter router = GoRouter(
    initialLocation: '/splash',
    routes: [
      _buildRoute(path: '/splash', child: const SplashScreen()),
      _buildRoute(
        path: '/login',
        child: BlocProvider(
          create: (_) => AuthBloc(_authRepository),
          child: LoginScreen(),
        ),
      ),
      _buildRoute(
        path: '/register',
        child: BlocProvider(
          create: (_) => AuthBloc(_authRepository),
          child: RegisterScreen(),
        ),
      ),
      _buildRoute(
        path: '/forgot',
        child: BlocProvider(
          create: (_) => AuthBloc(_authRepository),
          child: ForgotScreen(),
        ),
      ),
      _buildRoute(
        path: '/home',
        child: BlocProvider(
          create: (_) => AuthBloc(_authRepository),
          child: const MainNavScreen(),
        ),
      ),
      GoRoute(
        path: '/product',
        builder: (context, state) {
          final product = state.extra as Product;
          return BlocProvider(
            // <-- 1. Bọc bằng BlocProvider
            create:
                (context) => ProductDetailBloc(_productRepository)..add(
                  LoadProductDetail(product.id),
                ), // <-- 2. Tạo BLoC và tải dữ liệu
            child: ProductDetailScreen(product: product),
          );
        },
      ),
    ],
  );

  /// 🪄 Hiệu ứng Slide + Fade (mượt kiểu iOS/Material)
  static GoRoute _buildRoute({required String path, required Widget child}) {
    return GoRoute(
      path: path,
      pageBuilder:
          (context, state) => CustomTransitionPage<void>(
            key: state.pageKey,
            transitionDuration: const Duration(milliseconds: 350),
            reverseTransitionDuration: const Duration(milliseconds: 300),
            child: child,
            transitionsBuilder: (
              context,
              animation,
              secondaryAnimation,
              child,
            ) {
              // Fade và trượt nhẹ từ phải qua (kiểu iOS)
              final fade = CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
              );
              final offset = Tween<Offset>(
                begin: const Offset(0.1, 0), // từ phải qua
                end: Offset.zero,
              ).animate(fade);

              return FadeTransition(
                opacity: fade,
                child: SlideTransition(position: offset, child: child),
              );
            },
          ),
    );
  }
}
