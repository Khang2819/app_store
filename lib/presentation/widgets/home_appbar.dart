import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../assets/app_vector.dart';

class HomeAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String? title; // Tiêu đề tùy chỉnh
  final bool showBackButton; // Hiển thị nút quay lại hay không
  final VoidCallback? onBack; // Hành động khi nhấn nút quay lại
  final VoidCallback? onCartTap; // Hành động khi nhấn giỏ hàng

  const HomeAppbar({
    super.key,
    this.title,
    this.showBackButton = false,
    this.onBack,
    this.onCartTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Color(0xffDDB892),
      elevation: 3,
      surfaceTintColor: Colors.white,
      centerTitle: true,
      leading:
          showBackButton
              ? IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.white,
                  size: 22,
                ),
                onPressed: onBack ?? () => context.pop(),
              )
              : Padding(
                padding: const EdgeInsets.only(left: 12),
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.white,
                  child: ClipOval(
                    child: Image.asset(
                      AppVector.icon,
                      fit: BoxFit.contain,
                      width: 36,
                      height: 36,
                    ),
                  ),
                ),
              ),

      title: Text(
        title ?? 'Shop Coffe',
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      actions: [
        IconButton(
          onPressed: onCartTap ?? () {},
          icon: Icon(
            Icons.shopping_cart_outlined,
            color: Colors.white,
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
