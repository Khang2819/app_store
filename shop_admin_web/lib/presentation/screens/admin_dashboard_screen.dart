import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shop_admin_web/presentation/bloc/dashboard/admin_dashboard_bloc.dart';
import 'package:shop_admin_web/presentation/bloc/sidebar/sidebar_bloc.dart';
import '../bloc/dashboard/admin_dashboard_state.dart';
import '../bloc/order/orders_admin_bloc.dart';
import '../bloc/order/orders_admin_state.dart';
import '../bloc/sidebar/sidebar_state.dart';
import '../widgets/admin_sidebar.dart';
import '../widgets/dashboard_charts.dart';
import '../widgets/header_admin.dart';
import '../widgets/stat_card.dart';
import '../widgets/wellcome.dart';

class AdminLayoutScreen extends StatelessWidget {
  const AdminLayoutScreen({super.key});

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

  // ===================== Desktop Layout =====================
  Widget _buildDesktopLayout(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const AdminSidebar(isExpanded: true),
          Expanded(
            child: Column(
              children: [
                HeaderAdmin(),
                Expanded(
                  child: BlocBuilder<SidebarBloc, SidebarState>(
                    builder: (context, state) {
                      return DashboardContent(isMobile: false);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ===================== Mobile / Tablet Layout =====================
  Widget _buildMobileLayout(BuildContext context) {
    return Scaffold(
      drawer: const Drawer(child: AdminSidebar(isExpanded: true)),
      appBar: AppBar(title: const Text('Admin Dashboard')),
      body: BlocBuilder<SidebarBloc, SidebarState>(
        builder: (context, state) {
          return DashboardContent(isMobile: true);
        },
      ),
    );
  }
}

// ===================== Dashboard Content =====================
class DashboardContent extends StatelessWidget {
  final bool isMobile;
  const DashboardContent({super.key, this.isMobile = false});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminDashboardBloc, AdminDashboardState>(
      builder: (context, state) {
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wellcome(title: 'Chào mừng trở lại!', icon: Icons.waving_hand),
                const SizedBox(height: 24),
                const Text(
                  'Thống kê tổng quan',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [
                    Expanded(
                      child: StatCard(
                        icon: Icons.people_outline,
                        title: 'Người dùng',
                        value: state.totalUsers,
                        color: Colors.blue,
                        trend: state.userTrend,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: StatCard(
                        icon: Icons.shopping_bag_outlined,
                        title: 'Đơn hàng',
                        value: state.totalOrders,
                        color: Colors.green,
                        trend: state.orderTrend,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: StatCard(
                        icon: Icons.attach_money,
                        title: 'Doanh thu',
                        value: state.totalRevenue,
                        color: Colors.orange,
                        trend: state.revenueTrend,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: StatCard(
                        icon: Icons.inventory_2_outlined,
                        title: 'Sản phẩm',
                        value: state.totalProducts,
                        color: Colors.purple,
                        trend: state.productTrend,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Charts
                DashboardCharts(
                  isMobile: isMobile,
                  revenueData: state.monthlyRevenueData, // Lấy từ state Bloc
                  pieData: state.categoryData,
                ),
                // Quick Actions
                const Text(
                  'Thao tác nhanh',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Card(
                  elevation: 2,
                  child: Column(
                    children: [
                      _buildActionTile(
                        icon: Icons.person_add_outlined,
                        title: 'Quản lý người dùng',
                        subtitle: 'Xem và quản lý tài khoản',
                        onTap: () => context.go('/users'),
                      ),
                      const Divider(height: 1),
                      _buildActionTile(
                        icon: Icons.add_box_outlined,
                        title: 'Thêm sản phẩm',
                        subtitle: 'Thêm sản phẩm mới vào kho',
                        onTap: () => context.go('/products'),
                      ),
                      const Divider(height: 1),
                      _buildActionTile(
                        icon: Icons.receipt_long_outlined,
                        title: 'Quản lý đơn hàng',
                        subtitle: 'Xem và xử lý đơn hàng',
                        onTap: () => context.go('/orders'),
                      ),
                      const Divider(height: 1),
                      _buildActionTile(
                        icon: Icons.analytics_outlined,
                        title: 'Thêm banner quảng cáo',
                        subtitle: 'Xem báo cáo chi tiết',
                        onTap: () => context.go('/banner'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Recent Activities
                const Text(
                  'Hoạt động gần đây',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Card(
                  elevation: 2,
                  child: BlocBuilder<OrdersAdminBloc, OrdersAdminState>(
                    builder: (context, state) {
                      if (state.isLoading) {
                        return const Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      final recentOrders = state.orders.take(5).toList();

                      if (recentOrders.isEmpty) {
                        return const ListTile(
                          title: Text("Chưa có hoạt động nào"),
                        );
                      }

                      return ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: recentOrders.length,
                        separatorBuilder:
                            (context, index) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final order = recentOrders[index];
                          return _buildActivityTile(
                            icon: Icons.shopping_cart_outlined,
                            title:
                                'Đơn hàng mới #${order.id.substring(0, 5).toUpperCase()}',
                            subtitle:
                                'Khách hàng: ${order.address.fullName} - ₫${order.totalAmount}',
                            time: _formatTimestamp(
                              order.createdAt,
                            ), // Hàm tự viết để format ngày
                          );
                        },
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

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.blue[50],
        child: Icon(icon, color: Colors.blue[700]),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  Widget _buildActivityTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required String time,
  }) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.orange[50],
        child: Icon(icon, color: Colors.orange[700], size: 20),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle),
      trailing: Text(
        time,
        style: TextStyle(color: Colors.grey[500], fontSize: 12),
      ),
      dense: true,
    );
  }
}

String _formatTimestamp(DateTime? dateTime) {
  if (dateTime == null) return '';
  final now = DateTime.now();
  final difference = now.difference(dateTime);

  if (difference.inMinutes < 60) {
    return '${difference.inMinutes} phút trước';
  } else if (difference.inHours < 24) {
    return '${difference.inHours} giờ trước';
  } else {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }
}
