// lib/presentation/widgets/admin_sidebar.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shop_core/shop_core.dart';

import '../bloc/sidebar/sidebar_bloc.dart';
import '../bloc/sidebar/sidebar_event.dart';
import '../bloc/sidebar/sidebar_state.dart';

class AdminSidebar extends StatelessWidget {
  final bool isExpanded;
  final bool isDesktop;

  const AdminSidebar({
    super.key,
    required this.isExpanded,
    this.isDesktop = true,
  });

  // Tối ưu: chỉ tạo 1 lần
  static const List<Map<String, dynamic>> menuItems = [
    {
      'title': 'Dashboard',
      'icon': Icons.dashboard_outlined,
      'route': '/dashboard',
    },
    {'title': 'Người dùng', 'icon': Icons.people_outline, 'route': '/users'},
    {
      'title': 'Sản phẩm',
      'icon': Icons.inventory_2_outlined,
      'route': '/products',
    },
    {
      'title': 'Đơn hàng',
      'icon': Icons.shopping_bag_outlined,
      'route': '/orders',
    },
    {'title': 'Quảng cáo', 'icon': Icons.sell, 'route': '/banner'},
    {'title': 'Doanh mục', 'icon': Icons.category, 'route': '/category'},
    {
      'title': 'Thông báo',
      'icon': Icons.notifications,
      'route': '/notification',
    },
    {'title': 'Cài đặt', 'icon': Icons.settings_outlined, 'route': '/settings'},
  ];

  @override
  Widget build(BuildContext context) {
    const double condensedWidth = 70;
    const double expandedWidth = 250;

    // Gọn hơn — không cần else
    final double currentWidth = isExpanded ? expandedWidth : condensedWidth;

    return BlocBuilder<SidebarBloc, SidebarState>(
      builder: (context, state) {
        return Material(
          elevation: isDesktop ? 4 : 0,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: isDesktop ? currentWidth : expandedWidth,
            color: Colors.white,
            child: Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.only(top: 8),
                    itemCount: menuItems.length,
                    itemBuilder: (context, index) {
                      final item = menuItems[index];
                      return _buildMenuItem(
                        context,
                        index: index,
                        title: item['title']!,
                        icon: item['icon']!,
                        route: item['route']!,
                        isSelected: state.tabIndex == index,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ---------------- HEADER ----------------
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child:
          isExpanded
              ? const Row(
                children: [
                  SizedBox(width: 10),
                  Image(
                    image: AssetImage(AppVector.icon, package: 'shop_core'),
                    width: 32,
                    height: 32,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Admin Panel',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A73E8),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(width: 10),
                ],
              )
              : const Center(
                child: Image(
                  image: AssetImage(AppVector.icon, package: 'shop_core'),
                  width: 32,
                  height: 32,
                ),
              ),
    );
  }

  // ---------------- MENU ITEM ----------------
  Widget _buildMenuItem(
    BuildContext context, {
    required int index,
    required String title,
    required IconData icon,
    required String route,
    required bool isSelected,
  }) {
    final Color textColor = isSelected ? Colors.white : Colors.grey.shade700;
    final Color bgColor =
        isSelected ? const Color(0xFF1A73E8) : Colors.transparent;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isExpanded ? 10 : 0,
        vertical: 4,
      ),
      child: Material(
        borderRadius: BorderRadius.circular(8),
        color: bgColor,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () {
            context.read<SidebarBloc>().add(SelectPage(index));
            context.go(route);
            if (!isDesktop) Navigator.of(context).pop();
          },
          child: SizedBox(
            height: 48,
            child:
                isExpanded
                    ? Row(
                      children: [
                        const SizedBox(width: 10),
                        Icon(icon, size: 22, color: textColor),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            title,
                            style: TextStyle(
                              color: textColor,
                              fontSize: 16,
                              fontWeight:
                                  isSelected
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    )
                    : Center(child: Icon(icon, size: 24, color: textColor)),
          ),
        ),
      ),
    );
  }
}
