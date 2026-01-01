import 'package:flutter/material.dart';

import '../widgets/admin_sidebar.dart';
import '../widgets/header_admin.dart';
import '../widgets/search_admin.dart';
import '../widgets/wellcome.dart';

class AdminNotiScreen extends StatelessWidget {
  const AdminNotiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 800;
        return isMobile
            ? _buildMobileLayout(context)
            : _buildDesktopLayout(context);
      },
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Scaffold();
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          AdminSidebar(isExpanded: true),
          Expanded(
            child: Column(
              children: [
                HeaderAdmin(),
                Expanded(child: NotiContext(isMobile: false)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class NotiContext extends StatelessWidget {
  final bool isMobile;
  const NotiContext({super.key, required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            // ignore: deprecated_member_use
            Colors.blue.withOpacity(0.03),
            // ignore: deprecated_member_use
            Colors.purple.withOpacity(0.03),
          ],
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Wellcome(
              title: 'Thông báo',
              icon: Icons.notifications,
              buttonIcon: Icons.add_circle_outline,
              buttonText: 'Thêm thông báo',
              onPressed: () {},
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    // ignore: deprecated_member_use
                    color: const Color(0xFF667eea).withOpacity(0.5),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: SearchAdmin(text: 'Tìm kiếm thông báo'),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[200]!),
                        ),
                        child: DropdownButton<int>(
                          value: 10,
                          underline: const SizedBox(),
                          icon: Icon(
                            Icons.arrow_drop_down,
                            color: Colors.grey[600],
                          ),
                          items:
                              [10, 25, 50, 100].map((value) {
                                return DropdownMenuItem(
                                  value: value,
                                  child: Text('$value / trang'),
                                );
                              }).toList(),
                          onChanged: (value) {},
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
