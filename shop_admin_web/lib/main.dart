import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_admin_web/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shop_admin_web/routes/web_router.dart';
import 'package:shop_core/repositories/auth_login.dart';

import 'presentation/bloc/auth/auth_admin_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // web sẽ tự lấy config
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthAdminBloc(AuthRepository())),
      ],
      child: MaterialApp.router(
        title: 'Admin',
        debugShowCheckedModeBanner: false,
        routerConfig: WebRouter.router,
      ),
    );
  }
}
