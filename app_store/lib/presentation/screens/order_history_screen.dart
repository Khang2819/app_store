import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/order/order_bloc.dart';
import '../bloc/order/order_event.dart';
import '../bloc/order/order_state.dart';
import '../widgets/home_appbar.dart';
import '../widgets/showdialog.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFFF8F0),
      appBar: const HomeAppbar(title: 'Lịch sử đơn hàng', showBackButton: true),
      body: BlocBuilder<OrderBloc, OrderState>(
        builder: (context, state) {
          if (state is OrderLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xff2A4ECA)),
            );
          }

          if (state is OrderError) {
            return Center(
              child: Text(
                'Lỗi: ${state.message}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          if (state is OrderLoaded) {
            if (state.orders.isEmpty) {
              return const Center(child: Text('Bạn chưa có đơn hàng nào.'));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.orders.length,
              itemBuilder: (context, index) {
                final order = state.orders[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ExpansionTile(
                    // Loại bỏ icon mũi tên mặc định để dành toàn bộ chiều ngang cho Row
                    trailing: const SizedBox.shrink(),
                    // Thu hẹp padding lề phải để nút xóa sát mép hơn
                    tilePadding: const EdgeInsets.only(left: 16, right: 8),
                    title: Row(
                      children: [
                        // 1. Mã đơn hàng (Căn trái)
                        Expanded(
                          flex: 3,
                          child: Text(
                            '#${order.id.substring(0, 8).toUpperCase()}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                        // 2. Trạng thái (Căn giữa chính xác)
                        Expanded(
                          flex: 3,
                          child: Center(child: _buildStatusChip(order.status)),
                        ),

                        // 3. Nút xóa (Căn phải ngoài cùng)
                        Expanded(
                          flex: 2,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              icon: const Icon(
                                Icons.delete_outline,
                                color: Colors.red,
                                size: 22,
                              ),
                              onPressed: () {
                                AppDialog.showConfirmDialog(
                                  context,
                                  title: 'Xóa lịch sử',
                                  message:
                                      'Bạn có chắc chắn muốn xóa đơn hàng này?',
                                  onConfirm: () {
                                    context.read<OrderBloc>().add(
                                      DeleteOrder(order.id),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        Text(
                          'Ngày: ${order.createdAt.toDate().toString().split('.')[0]}',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Tổng: ${_formatPrice(order.totalAmount)}',
                          style: const TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    children: [
                      // Hiển thị danh sách sản phẩm khi nhấn vào đơn hàng
                      ...order.items.map(
                        (item) => ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              item.imageUrl,
                              width: 45,
                              height: 45,
                              fit: BoxFit.cover,
                              errorBuilder:
                                  (context, error, stackTrace) =>
                                      const Icon(Icons.broken_image),
                            ),
                          ),
                          title: Text(
                            item.productName,
                            style: const TextStyle(fontSize: 14),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            'Số lượng: ${item.quantity}',
                            style: const TextStyle(fontSize: 12),
                          ),
                          trailing: Text(
                            _formatPrice(item.price),
                            style: const TextStyle(fontSize: 13),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  String _formatPrice(int price) {
    return '${price.toString().replaceAllMapped(RegExp(r"(\d{1,3})(?=(\d{3})+(?!\d))"), (Match m) => "${m[1]},")}đ';
  }

  Widget _buildStatusChip(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color:
            status.toLowerCase() == 'completed'
                ? Colors.green[100]
                : Colors.orange[100],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          color:
              status.toLowerCase() == 'completed'
                  ? Colors.green[800]
                  : Colors.orange[800],
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
