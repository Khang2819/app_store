import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'locale_event.dart';
import 'locale_state.dart';

class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  LanguageBloc() : super(const LanguageState(locale: Locale('vi'))) {
    // Khi khởi tạo, ta sẽ kiểm tra ngôn ngữ đã lưu trong SharedPreferences
    // Nếu có thì sử dụng ngôn ngữ đó, nếu không thì mặc định là tiếng Việt
    on<LanguageStarted>((event, emit) async {
      final prefs = await SharedPreferences.getInstance();
      final localeCode = prefs.getString('locale') ?? 'vi';
      emit(LanguageState(locale: Locale(localeCode)));
    });
    // Khi có sự kiện thay đổi ngôn ngữ, ta sẽ cập nhật SharedPreferences và phát ra trạng thái mới
    on<LanguageChange>((event, emit) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('locale', event.locale.languageCode);
      emit(LanguageState(locale: event.locale));
    });
  }
}
