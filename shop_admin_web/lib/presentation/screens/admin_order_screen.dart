import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_core/shop_core.dart';

import '../bloc/order/orders_admin_bloc.dart';
import '../bloc/order/orders_admin_event.dart';
import '../bloc/order/orders_admin_state.dart';
import '../widgets/admin_sidebar.dart';
import '../widgets/containerbox.dart';
import '../widgets/fiterchip.dart';
import '../widgets/header_admin.dart';
import '../widgets/order_table_row.dart';
import '../widgets/search_admin.dart';
import '../widgets/tablerow.dart';
import '../widgets/wellcome.dart';

class AdminOrderScreen extends StatelessWidget {
  const AdminOrderScreen({super.key});

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

  Widget _buildDesktopLayout(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          AdminSidebar(isExpanded: true),
          Expanded(
            child: Column(
              children: [
                HeaderAdmin(),
                Expanded(child: OrderContext(isMobile: false)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Scaffold();
  }
}

class OrderContext extends StatelessWidget {
  final bool isMobile;
  const OrderContext({super.key, this.isMobile = false});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrdersAdminBloc, OrdersAdminState>(
      builder: (context, state) {
        final sourceList =
            state.allOrders.isNotEmpty ? state.allOrders : state.orders;

        final totalCount = sourceList.length;
        final pendingCount =
            sourceList.where((o) {
              final s = o.status.toLowerCase();
              return s.contains('chờ') || s.contains('đang xử lý');
            }).length;

        final shippingCount =
            sourceList
                .where((o) => o.status.toLowerCase().contains('vận chuyển'))
                .length;

        final completedCount =
            sourceList
                .where((o) => o.status.toLowerCase() == 'đã giao hàng')
                .length;
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
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Wellcome(
                  title: 'Quản lý đơn hàng',
                  icon: Icons.shopping_bag_outlined,
                  buttonText: 'Xuất file Excel',
                  buttonIcon: Icons.download,
                  onPressed: () {},
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Containerbox(
                        title: 'Tổng số đơn hàng',
                        count: totalCount,
                        color: Color(0xFF667eea),
                        icon: Icons.shopping_bag_rounded,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Containerbox(
                        title: 'Chờ xử lý',
                        count: pendingCount,
                        color: Color(0xFFFF9800),
                        icon: Icons.pending_actions_rounded,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Containerbox(
                        title: 'Đang giao',
                        count: shippingCount,
                        color: Color(0xFF00BCD4),
                        icon: Icons.local_shipping_rounded,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Containerbox(
                        title: 'Hoàn thành',
                        count: completedCount,
                        color: Colors.green,
                        icon: Icons.check_circle,
                      ),
                    ),
                  ],
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
                          Expanded(
                            child: SearchAdmin(
                              text: 'Tìm kiếm theo tên, mã đơn hàng',
                              onChanged: (query) {
                                context.read<OrdersAdminBloc>().add(
                                  SearchOrders(query),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          Fiterchip(
                            title: 'Tất cả',
                            value: 'all',
                            currentValue: state.filterStatus,
                            icon: Icons.apps,
                            onTap:
                                () => context.read<OrdersAdminBloc>().add(
                                  const FilterOrders('all'),
                                ),
                          ),
                          Fiterchip(
                            title: 'Chờ xử lý',
                            value: 'pending',
                            currentValue: state.filterStatus,
                            icon: Icons.hourglass_empty,
                            onTap:
                                () => context.read<OrdersAdminBloc>().add(
                                  const FilterOrders('pending'),
                                ),
                          ),
                          Fiterchip(
                            title: 'Đang giao',
                            value: 'shipping',
                            currentValue: state.filterStatus,
                            icon: Icons.local_shipping,
                            onTap:
                                () => context.read<OrdersAdminBloc>().add(
                                  const FilterOrders('shipping'),
                                ),
                          ),
                          Fiterchip(
                            title: 'Hoàn thành',
                            value: 'delivered',
                            currentValue: state.filterStatus,
                            icon: Icons.check_circle,
                            onTap:
                                () => context.read<OrdersAdminBloc>().add(
                                  const FilterOrders('delivered'),
                                ),
                          ),
                          Fiterchip(
                            title: 'Đã hủy',
                            value: 'cancelled',
                            currentValue: state.filterStatus,
                            icon: Icons.cancel,
                            onTap:
                                () => context.read<OrdersAdminBloc>().add(
                                  const FilterOrders('cancelled'),
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        // ignore: deprecated_member_use
                        color: const Color(0xFF667eea).withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Table Header
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.grey[50]!, Colors.grey[100]!],
                          ),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: _buildHeaderCell(
                                'Mã đơn',
                                Icons.confirmation_number,
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: _buildHeaderCell(
                                'Khách hàng',
                                Icons.person,
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: _buildHeaderCell(
                                'Ngày đặt',
                                Icons.event_outlined,
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: _buildHeaderCell(
                                'Tổng tiền',
                                Icons.payments_outlined,
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: _buildHeaderCell(
                                'Thanh toán',
                                Icons.credit_card_outlined,
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: _buildHeaderCell(
                                'Trạng thái',
                                Icons.local_shipping_outlined,
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: _buildHeaderCell(
                                'Thao tác',
                                Icons.settings,
                              ),
                            ),
                          ],
                        ),
                      ),
                      _buildOrderList(context, state),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeaderCell(String text, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  Widget _buildOrderList(BuildContext context, OrdersAdminState state) {
    if (state.isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(40.0),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (state.orders.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(40.0),
          child: Text('Chưa có đơn hàng nào'),
        ),
      );
    }
    return Column(
      children: List.generate(state.orders.length, (index) {
        final order = state.orders[index];
        return TableRowItem(
          index: index,
          totalUsers: state.orders.length,
          child: OrderTableRow(
            order: order,
            onEdit: () => _showStatusPicker(context, order),
            onDelete: () => _confirmDelete(context, order),
          ),
        );
      }),
    );
  }

  void _showStatusPicker(BuildContext context, OrderModel order) {
    final List<String> statuses = [
      'đang chờ xử lý',
      'đang xử lý',
      'đã vận chuyển',
      'đã giao hàng',
      'đã hủy',
    ];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Cập nhật trạng thái đơn hàng',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ...statuses.map(
                (status) => ListTile(
                  title: Text(status.toUpperCase()),
                  trailing:
                      order.status == status
                          ? const Icon(Icons.check, color: Colors.green)
                          : null,
                  onTap: () {
                    context.read<OrdersAdminBloc>().add(
                      UpdateOrderStatus(
                        userId: order.userId,
                        orderId: order.id,
                        newStatus: status,
                      ),
                    );
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, OrderModel order) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Xác nhận xóa đơn hàng'),
          content: RichText(
            text: TextSpan(
              style: const TextStyle(color: Colors.black),
              children: [
                const TextSpan(text: 'Bạn có chắc muốn xóa đơn hàng '),
                TextSpan(
                  text: '#${order.id.substring(0, 8).toUpperCase()}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const TextSpan(
                  text: ' không?\nHành động này không thể hoàn tác.',
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext), // Đóng dialog
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                // Gọi sự kiện DeleteOrder trong Bloc
                context.read<OrdersAdminBloc>().add(
                  DeleteOrder(order.id, order.userId),
                );

                // Đóng dialog
                Navigator.pop(dialogContext);

                // Hiển thị thông báo
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Đang xóa đơn hàng...'),
                    backgroundColor: Colors.orange,
                    duration: Duration(seconds: 1),
                  ),
                );
              },
              child: const Text('Xóa vĩnh viễn'),
            ),
          ],
        );
      },
    );
  }
}
