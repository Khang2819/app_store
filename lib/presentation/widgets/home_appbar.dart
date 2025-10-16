import 'package:flutter/material.dart';

class HomeAppbar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
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
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
