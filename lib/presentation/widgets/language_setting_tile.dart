import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../l10n/app_localizations.dart';
import '../bloc/language/locale_bloc.dart';
import '../bloc/language/locale_event.dart';
import '../bloc/language/locale_state.dart';

class LanguageSettingTile extends StatelessWidget {
  const LanguageSettingTile({super.key});
  @override
  Widget build(BuildContext context) {
    final supportedLocales = AppLocalizations.supportedLocales;

    String getLocaleName(Locale locale) {
      switch (locale.languageCode) {
        case 'vi':
          return 'Tiếng Việt';
        case 'en':
          return 'English';
        case 'ja':
          return '日本語';
        default:
          return locale.languageCode;
      }
    }

    return BlocBuilder<LanguageBloc, LanguageState>(
      builder: (context, state) {
        return ListTile(
          leading: Icon(Icons.language),
          title: const Text('Ngôn ngữ'),
          trailing: DropdownButtonHideUnderline(
            child: DropdownButton<Locale>(
              value: state.locale,
              icon: Icon(Icons.arrow_drop_down, color: Colors.grey[600]),

              items:
                  supportedLocales.map((locale) {
                    return DropdownMenuItem<Locale>(
                      value: locale,
                      child: Text(getLocaleName(locale)),
                    );
                  }).toList(),
              onChanged: (Locale? newLocale) {
                if (newLocale != null) {
                  context.read<LanguageBloc>().add(LanguageChange(newLocale));
                }
              },
            ),
          ),
        );
      },
    );
  }
}
