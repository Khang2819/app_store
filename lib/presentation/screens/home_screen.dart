import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notification_add),
            onPressed: () async {},
          ),
        ],
      ),
      body: Center(child: Text('Xin chào, ${user?.email ?? 'Người dùng'}!')),
    );
  }
}
