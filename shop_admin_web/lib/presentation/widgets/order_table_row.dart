import 'package:flutter/material.dart';

/// =======================
/// 1️⃣ MODEL GIẢ
/// =======================
class UsersModels {
  final String id;
  final String? name;
  final String? photoUrl;

  UsersModels({required this.id, this.name, this.photoUrl});
}

/// =======================
/// 2️⃣ DỮ LIỆU GIẢ
/// =======================
final List<UsersModels> mockUsers = [
  UsersModels(id: 'DH-001', name: 'Nguyễn Văn Khang', photoUrl: null),
  UsersModels(id: 'DH-002', name: 'Trần Thị Mai', photoUrl: null),
  UsersModels(id: 'DH-003', name: 'Lê Quốc Anh', photoUrl: null),
  UsersModels(id: 'DH-001', name: 'Nguyễn Văn Khang', photoUrl: null),
  UsersModels(
    id: 'DH-002',
    name: 'Trần Thị Mai',
    photoUrl: 'https://i.pravatar.cc/150?img=3',
  ),
  UsersModels(
    id: 'DH-003',
    name: 'Lê Quốc Anh',
    photoUrl: 'https://i.pravatar.cc/150?img=5',
  ),
  UsersModels(id: 'DH-001', name: 'Nguyễn Văn Khang', photoUrl: null),
  UsersModels(
    id: 'DH-002',
    name: 'Trần Thị Mai',
    photoUrl: 'https://i.pravatar.cc/150?img=3',
  ),
  UsersModels(
    id: 'DH-003',
    name: 'Lê Quốc Anh',
    photoUrl: 'https://i.pravatar.cc/150?img=5',
  ),
];

/// =======================
/// 3️⃣ ORDER TABLE ROW
/// =======================
class OrderTableRow extends StatelessWidget {
  final UsersModels user;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const OrderTableRow({
    super.key,
    required this.user,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          // Mã đơn
          Expanded(
            flex: 1,
            child: Text(
              user.id,
              style: TextStyle(
                color: Colors.blue[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          // Khách hàng
          Expanded(
            flex: 2,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundImage:
                      user.photoUrl != null
                          ? NetworkImage(user.photoUrl!)
                          : null,
                  child:
                      user.photoUrl == null
                          ? Text(
                            user.name?.isNotEmpty == true
                                ? user.name![0].toUpperCase()
                                : 'U',
                            style: const TextStyle(color: Colors.white),
                          )
                          : null,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    user.name ?? 'No Name',
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),

          // Ngày đặt
          Expanded(
            flex: 1,
            child: Text(
              '12/12/2025',
              style: TextStyle(color: Colors.grey[700]),
            ),
          ),

          // Tổng tiền
          Expanded(
            flex: 1,
            child: Text(
              '1.250.000 ₫',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
          ),

          // Thanh toán
          const Expanded(flex: 1, child: Text('COD')),

          // Trạng thái
          Expanded(flex: 1, child: _buildChip('Đang giá', Colors.orange)),

          // Thao tác
          Expanded(
            flex: 1,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Tooltip(
                  message: 'Xem chi tiết',
                  child: IconButton(
                    icon: const Icon(Icons.visibility_outlined),
                    onPressed: () {},
                  ),
                ),
                Tooltip(
                  message: 'Chỉnh sửa',
                  child: IconButton(
                    icon: Icon(Icons.edit_outlined, color: Colors.blue[600]),
                    onPressed: onEdit,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Helper cho chip hiển thị trạng thái
  Widget _buildChip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
