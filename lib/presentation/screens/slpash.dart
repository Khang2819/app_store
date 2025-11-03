import 'package:bloc_app/assets/app_vector.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'dart:async'; // Cần import này

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  void _navigateToNextScreen() {
    // Chờ đồng thời 2 điều kiện: delay 2 giây VÀ lấy trạng thái Auth đầu tiên
    Future.wait([
      Future.delayed(const Duration(seconds: 2)),
      FirebaseAuth.instance.authStateChanges().first,
    ]).then((results) {
      if (!mounted) return;

      // Lấy kết quả User từ phần tử thứ hai của Future.wait
      final User? user = results[1] as User?;

      if (user != null) {
        context.go('/home'); // Đã đăng nhập
      } else {
        context.go('/login'); // Chưa đăng nhập
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(AppVector.logo, width: 150, height: 150),
            const SizedBox(height: 20),
            Text(
              'Shop Coffee',
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
