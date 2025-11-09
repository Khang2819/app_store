import 'package:bloc_app/presentation/bloc/review/review_bloc.dart';
import 'package:bloc_app/presentation/bloc/review/review_event.dart';
import 'package:bloc_app/presentation/bloc/see_all_screen/see_all_screen_bloc.dart';
import 'package:bloc_app/presentation/bloc/see_all_screen/see_all_screen_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shop_core/shop_core.dart';
import '../presentation/bloc/auth/auth_bloc.dart';
import '../presentation/bloc/category_products/category_products_bloc.dart';
import '../presentation/bloc/favorites/favorites_bloc.dart';
import '../presentation/bloc/product_detail/product_detail_bloc.dart';
import '../presentation/bloc/product_detail/product_detail_event.dart';
import '../presentation/screens/all_products_page.dart';
import '../presentation/screens/all_review_screen.dart';
import '../presentation/screens/category_products_screen.dart';
import '../presentation/screens/edit_profile_screen.dart';
import '../presentation/screens/favorites_screen.dart';
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
      _buildRoute(path: '/home', child: const MainNavScreen()),
      GoRoute(
        path: '/product',
        builder: (context, state) {
          final product = state.extra as Product;
          return BlocProvider(
            create:
                (context) => ProductDetailBloc(_productRepository)..add(
                  LoadProductDetail(product.id),
                ), // <-- 2. Tạo BLoC và tải dữ liệu
            child: ProductDetailScreen(product: product),
          );
        },
      ),
      GoRoute(
        path: '/favorites',
        builder: (context, state) {
          // Cung cấp FavoritesBloc cho màn hình Yêu thích
          return BlocProvider(
            create: (context) => FavoritesBloc(_productRepository),
            child: const FavoritesScreen(),
          );
        },
      ),
      GoRoute(
        path: '/all-products',
        builder: (context, state) {
          return BlocProvider(
            create:
                (_) => SeeAllScreenBloc(_productRepository)..add(LoadSeeAll()),
            child: AllProductsPage(),
          );
        },
      ),
      GoRoute(
        path: '/all-review',
        builder: (context, state) {
          final product = state.extra as Product;

          return BlocProvider(
            create:
                (_) => ReviewBloc(
                  _productRepository,
                ) // 2. Dùng _productRepository
                ..add(LoadReview(product.id)), // 3. Thêm sự kiện với productId
            child: AllReviewScreen(),
          );
        },
      ),
      GoRoute(
        path: '/category-products',
        builder: (context, state) {
          final category = state.extra as Category;
          return BlocProvider(
            create: (context) => CategoryProductsBloc(_productRepository),
            child: CategoryProductsScreen(category: category),
          );
        },
      ),

      _buildRoute(path: '/edit-profile', child: const EditProfileScreen()),
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
