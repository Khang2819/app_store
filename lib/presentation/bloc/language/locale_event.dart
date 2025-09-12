import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class LanguageEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

// Sự kiện khởi tạo để kiểm tra ngôn ngữ đã lưu trong SharedPreferences
class LanguageStarted extends LanguageEvent {}

// Sự kiện thay đổi ngôn ngữ
class LanguageChange extends LanguageEvent {
  final Locale locale;

  LanguageChange(this.locale);

  @override
  List<Object?> get props => [locale];
}
