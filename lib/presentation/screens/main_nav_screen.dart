import 'package:bloc_app/presentation/screens/home_screen.dart';
import 'package:flutter/material.dart';

class MainNavScreen extends StatelessWidget {
  const MainNavScreen({super.key});

  final List<Widget> _screen = const [HomeScreen()];

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
