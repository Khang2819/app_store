import 'package:bloc_app/presentation/widgets/my_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/home/home_bloc.dart';
import '../bloc/home/home_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 3,
          surfaceTintColor: Colors.white,
          titleSpacing: 0,
          title: Row(
            children: [
              const SizedBox(width: 10),
              CircleAvatar(
                radius: 18,
                // ignore: deprecated_member_use
                backgroundColor: const Color(0xff8B5E3C).withOpacity(0.15),
                child: const Icon(Icons.local_cafe, color: Color(0xff8B5E3C)),
              ),
              const SizedBox(width: 8),
              const Text(
                'E-Commerce',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff8B5E3C),
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.shopping_cart_outlined,
                color: Colors.black87,
                size: 26,
              ),
            ),
            const SizedBox(width: 10),
          ],
        ),
        body: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Column(
                children: const [
                  MySearchBar(),
                  SizedBox(height: 20),
                  Text(
                    "Danh mục nổi bật",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
