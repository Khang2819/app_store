import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../data/repositories/auth_login.dart';
import '../presentation/bloc/auth/auth_bloc.dart';
import '../presentation/screens/forgot_screen.dart';
import '../presentation/screens/home_screen.dart';
import '../presentation/screens/login_screen.dart';
import '../presentation/screens/register_screen.dart';
import '../presentation/screens/slpash.dart';

class AppRouter {
  static final AuthRepository _authRepository = AuthRepository();
  static final GoRouter router = GoRouter(
    initialLocation: '/splash',
    // redirect: (BuildContext context, GoRouterState state) {
    //   final authState = context.read<AuthBloc>().state;
    //   final isLoggingIn =
    //       state.matchedLocation == '/login' ||
    //       state.matchedLocation == '/register';
    //   if (authState is AuthInitial) {
    //     return '/splash';
    //   }
    //   if (authState is AuthUnauthenticated && !isLoggingIn) {
    //     return '/login';
    //   }

    //   if (authState is AuthAuthenticated && isLoggingIn) {
    //     return '/home';
    //   }
    // },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder:
            (context, state) => BlocProvider(
              create: (_) => AuthBloc(_authRepository),
              child: LoginScreen(),
            ),
      ),
      GoRoute(
        path: '/register',
        builder:
            (context, state) => BlocProvider(
              create: (_) => AuthBloc(_authRepository),
              child: RegisterScreen(),
            ),
      ),
      GoRoute(
        path: '/forgot',
        builder: (context, state) => const ForgotScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(), // Thêm route này
      ),
      // ...
    ],
  );
}
