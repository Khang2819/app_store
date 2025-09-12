import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:bloc_app/core/themes.dart';
import 'package:bloc_app/l10n/app_localizations.dart';
import 'package:bloc_app/presentation/bloc/themes/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'presentation/bloc/language/locale_bloc.dart';
import 'presentation/bloc/language/locale_event.dart';
import 'presentation/bloc/language/locale_state.dart';
import 'routers/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ThemeCubit()),
        BlocProvider(
          create: (context) => LanguageBloc()..add(LanguageStarted()),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, state) {
          return BlocBuilder<LanguageBloc, LanguageState>(
            builder: (context, localeState) {
              return MaterialApp.router(
                title: 'Shop App',
                debugShowCheckedModeBanner: false,
                theme: AppThemes.lightTheme,
                darkTheme: AppThemes.darkTheme,
                // themeMode: state.themeMode,
                //hỗ trợ đa ngôn ngữ
                locale: localeState.locale,
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: const [
                  Locale('vi', 'VI'), // Vietnamese
                  Locale('en', 'US'), // English
                  Locale('ja', 'JA'), // Japanese
                ],
                // điều hướng đến router
                routerConfig: AppRouter.router,
              );
            },
          );
        },
      ),
    );
  }
}
