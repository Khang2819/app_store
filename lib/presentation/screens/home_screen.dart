import 'package:bloc_app/presentation/widgets/my_search_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: const Color(
                            0xff2A4ECA,
                            // ignore: deprecated_member_use
                          ).withOpacity(0.1),
                          child: const Icon(
                            Icons.storefront,
                            color: Color(0xff2A4ECA),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Shop Khang',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff2A4ECA),
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.shopping_cart_outlined,
                        color: Colors.black87,
                        size: 28,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              MySearchBar(),
            ],
          ),
        ),
      ),
    );
  }
}
