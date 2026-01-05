import 'package:flutter/material.dart';
import 'package:shop_core/shop_core.dart';

class BannerTableRow extends StatelessWidget {
  final BannerModel banner;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onPause;
  final bool isActive;

  const BannerTableRow({
    super.key,
    required this.banner,
    required this.onEdit,
    required this.onDelete,
    required this.onPause,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    // Tạm dùng isActive để xác định màu và chữ
    final statusText = isActive ? 'Hoạt động' : 'Tạm dừng';
    final statusColor = isActive ? Colors.green : Colors.orange;

    // Giả định tiêu đề và mô tả được lấy từ targetId và targetType
    final title =
        '${banner.targetType == 'product'
            ? 'Quảng cáo Sản phẩm'
            : banner.targetType == 'category'
            ? 'Quảng cáo Danh mục'
            : 'Khuyến mãi đặc biệt'} (Order: ${banner.order})';
    final linkText = 'Link: /${banner.targetType}/${banner.targetId}';

    return Row(
      children: [
        // 1. Hình ảnh - ĐÃ CẬP NHẬT: Dùng BoxFit.fill
        Expanded(
          flex: 2,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child:
                banner.imageUrl.isNotEmpty
                    ? Image.network(
                      banner.imageUrl,
                      height: 200, // Chiều cao cố định
                      fit:
                          BoxFit
                              .fill, // SỬA: Dùng FILL để lấp đầy cả chiều rộng và chiều cao
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 200,
                          color: Colors.grey[300],
                          child: const Icon(
                            Icons.broken_image,
                            size: 40,
                            color: Colors.grey,
                          ),
                        );
                      },
                    )
                    : Container(
                      height: 200,
                      color: Colors.grey[200],
                      child: const Icon(
                        Icons.image_not_supported_outlined,
                        color: Colors.grey,
                      ),
                    ),
          ),
        ),

        // 2. Thông tin (Tiêu đề và Link)
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  linkText,
                  style: TextStyle(color: Colors.blue[600], fontSize: 13),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),

        // 3. Trạng thái
        Expanded(flex: 1, child: _buildChip(statusText, statusColor)),

        // 4. Hành động
        Expanded(
          flex: 1,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Tooltip(
                message: isActive ? 'Tạm dừng' : 'Kích hoạt',
                child: IconButton(
                  onPressed: onPause,
                  icon: Icon(
                    isActive ? Icons.pause_circle : Icons.play_circle,
                    color: isActive ? Colors.orange[600] : Colors.green[600],
                  ),
                ),
              ),
              Tooltip(
                message: 'Chỉnh sửa',
                child: IconButton(
                  onPressed: onEdit,
                  icon: Icon(Icons.edit_outlined, color: Colors.blue[600]),
                ),
              ),
              Tooltip(
                message: 'Xóa',
                child: IconButton(
                  onPressed: onDelete,
                  icon: Icon(Icons.delete_outlined, color: Colors.red[600]),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildChip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        // ignore: deprecated_member_use
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
