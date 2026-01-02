import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_admin_web/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shop_admin_web/presentation/bloc/banner/banner_admin_bloc.dart';
import 'package:shop_admin_web/presentation/bloc/banner/banner_admin_event.dart';
import 'package:shop_admin_web/presentation/bloc/category/category_admin_bloc.dart';
import 'package:shop_admin_web/presentation/bloc/products/products_admin_event.dart';
import 'package:shop_admin_web/routes/web_router.dart';
import 'package:shop_core/shop_core.dart';

import 'presentation/bloc/auth/auth_admin_bloc.dart';
import 'presentation/bloc/category/category_admin_event.dart';
import 'presentation/bloc/dashboard/admin_dashboard_bloc.dart';
import 'presentation/bloc/dashboard/admin_dashboard_event.dart';
import 'presentation/bloc/order/orders_admin_bloc.dart';
import 'presentation/bloc/order/orders_admin_event.dart';
import 'presentation/bloc/products/products_admin_bloc.dart';
import 'presentation/bloc/sidebar/sidebar_bloc.dart';
import 'presentation/bloc/users/users_admin_bloc.dart';
import 'presentation/bloc/users/users_admin_event.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    final authRepository = AuthRepository(isWebAdmin: true);
    final productRepository = ProductRepository();
    final userRepository = UserRepository();
    final bannerRepository = BannerRepository();
    return RepositoryProvider.value(
      value: authRepository,

      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => AuthAdminBloc(authRepository)),
          BlocProvider(create: (context) => SidebarBloc()),
          BlocProvider(
            create:
                (context) => AdminDashboardBloc(
                  productRepository: productRepository,
                  userRepository: userRepository,
                )..add(LoadDashboardData()),
          ),
          BlocProvider(
            create:
                (context) =>
                    UsersAdminBloc(userRepository: userRepository)
                      ..add((LoadUsers())),
          ),
          BlocProvider(
            create:
                (context) =>
                    ProductsAdminBloc(productRepository: productRepository)
                      ..add(LoadProducts()),
          ),
          BlocProvider(
            create:
                (context) =>
                    BannerAdminBloc(bannerRepository: bannerRepository)
                      ..add(LoadBanner()),
          ),
          BlocProvider(
            create:
                (context) =>
                    CategoryAdminBloc(productRepository: productRepository)
                      ..add(LoadCategories()),
          ),
          BlocProvider(
            create: (context) => OrdersAdminBloc()..add(LoadOrders()),
          ),
        ],
        child: MaterialApp.router(
          title: 'Admin',
          debugShowCheckedModeBanner: false,
          routerConfig: WebRouter.router,
        ),
      ),
    );
  }
}
