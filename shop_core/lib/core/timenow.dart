import 'package:flutter/material.dart';

class Timenow {
  /// Lấy thời gian hiện tại của Việt Nam
  static DateTime now() {
    return DateTime.now();
  }

  /// Trả về buổi hiện tại (sáng, trưa, chiều, tối, khuya)
  static String getTimeOfDay() {
    final hour = now().hour;

    if (hour >= 5 && hour < 11) return "Buổi sáng";
    if (hour >= 11 && hour < 13) return "Buổi trưa";
    if (hour >= 13 && hour < 18) return "Buổi chiều";
    if (hour >= 18 && hour < 23) return "Buổi tối";

    return "Buổi khuya";
  }

  static Stream<DateTime> streamTime() {
    return Stream.periodic(const Duration(seconds: 1), (_) => DateTime.now());
  }

  static String formatTime(DateTime time) {
    final h = time.hour.toString().padLeft(2, '0');
    final m = time.minute.toString().padLeft(2, '0');
    final s = time.second.toString().padLeft(2, '0');

    return "$h:$m:$s";
  }

  static IconData getTimeIcon() {
    final hour = DateTime.now().hour;

    if (hour >= 5 && hour < 11) return Icons.wb_sunny;
    if (hour >= 11 && hour < 13) return Icons.wb_sunny_outlined;
    if (hour >= 13 && hour < 18) return Icons.cloud_outlined;
    if (hour >= 18 && hour < 23) return Icons.nightlight_round;
    return Icons.nights_stay;
  }

  static Color getTimeColor() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 11) return Colors.orange;
    if (hour >= 11 && hour < 13) return Colors.amber;
    if (hour >= 13 && hour < 18) return Colors.deepOrange;
    if (hour >= 18 && hour < 23) return Colors.indigo;
    return Colors.blueGrey;
  }
}
