import 'package:flutter/material.dart';
import 'package:shop_core/shop_core.dart';
import 'package:intl/intl.dart';

class OrderTableRow extends StatelessWidget {
  final OrderModel order;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const OrderTableRow({
    super.key,
    required this.order,
    required this.onEdit,
    required this.onDelete,
  });

  void _showDetail(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              'Chi tiết đơn hàng #${order.id.substring(0, 6).toUpperCase()}',
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Người nhận: ${order.address.fullName}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('Số điện thoại: ${order.address.phoneNumber}'),
                // Chỉ hiển thị địa chỉ chi tiết
                Text('Địa chỉ: ${order.address.detailAddress}'),
                const Divider(),
                const Text(
                  'Sản phẩm:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ...order.items.map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '• ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Expanded(
                          child: Text(
                            item.productName,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'x${item.quantity}',
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
                Text(
                  'Ngày đặt: ${DateFormat('dd/MM/yyyy HH:mm').format(order.createdAt)}',
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Đóng', style: TextStyle(color: Colors.blue)),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          // 1. Mã đơn
          Expanded(
            flex: 1,
            child: Text(
              order.id.substring(0, 8).toUpperCase(),
              style: TextStyle(
                color: Colors.blue[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          // 2. Khách hàng (Có Avatar)
          Expanded(
            flex: 2,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.grey[200],
                  // Nếu bạn có link ảnh user trong order.address hoặc một model user đi kèm
                  // Ở đây giả định hiển thị chữ cái đầu nếu không có ảnh
                  child: Text(
                    order.address.fullName.isNotEmpty
                        ? order.address.fullName[0].toUpperCase()
                        : 'U',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.blueGrey,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    order.address.fullName,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),

          // 3. Ngày đặt
          Expanded(
            flex: 1,
            child: Text(
              DateFormat('dd/MM/yyyy').format(order.createdAt),
              style: TextStyle(color: Colors.grey[700]),
            ),
          ),

          // 4. Tổng tiền
          Expanded(
            flex: 1,
            child: Text(
              '${NumberFormat('#,###').format(order.totalAmount)} ₫',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
          ),

          // 5. Thanh toán
          const Expanded(flex: 1, child: Text('COD')),

          // 6. Trạng thái
          Expanded(child: _buildStatusChip(order.status)),

          // 7. Thao tác
          Expanded(
            flex: 1,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Tooltip(
                  message: 'Xem chi tiết',
                  child: IconButton(
                    icon: const Icon(Icons.visibility_outlined),
                    onPressed: () => _showDetail(context),
                  ),
                ),
                Tooltip(
                  message: 'Chỉnh sửa',
                  child: IconButton(
                    icon: Icon(Icons.edit_outlined, color: Colors.blue[600]),
                    onPressed: onEdit,
                  ),
                ),
                Tooltip(
                  message: 'Chỉnh sửa',
                  child: IconButton(
                    icon: Icon(Icons.delete_forever, color: Colors.red[600]),
                    onPressed: onDelete,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    switch (status.toLowerCase()) {
      case 'hoàn thành':
        color = Colors.green;
        break;
      case 'pending':
        color = Colors.orange;
        break;
      case 'cancelled':
        color = Colors.red;
        break;
      default:
        color = Colors.blue;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
