import 'package:flutter/material.dart';
import 'package:shop_core/shop_core.dart';

class ProductTableRow extends StatelessWidget {
  final Product product;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ProductTableRow({
    super.key,
    required this.product,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    // Lấy tên tiếng Việt (vi) hoặc tên đầu tiên nếu không có 'vi'
    final productName = product.name['vi'] ?? product.name.values.first;

    // Giả lập tồn kho (cần trường tồn kho thực tế trong Product Model)
    final stockQuantity = 100 - product.soldCount;
    final stockColor =
        stockQuantity > 20
            ? Colors.green
            : (stockQuantity > 0 ? Colors.orange : Colors.red);
    final stockText = stockQuantity > 0 ? '$stockQuantity' : 'Hết hàng';

    // Format giá
    final priceString = product.price
        .toStringAsFixed(0)
        .replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        );

    return Row(
      children: [
        // 1. Sản phẩm (Tên & Ảnh)
        Expanded(
          flex: 3,
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: NetworkImage(product.imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  productName ?? 'No Name',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
            ],
          ),
        ),

        // 2. Giá
        Expanded(
          flex: 1,
          child: Text(
            '$priceString ₫',
            style: TextStyle(
              color: Colors.grey[800],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),

        // 3. Đã bán
        Expanded(
          flex: 1,
          child: Text(
            '${product.soldCount}',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ),

        // 4. Tồn kho
        Expanded(flex: 1, child: _buildChip(stockText, stockColor)),

        // 5. Đánh giá
        Expanded(
          flex: 1,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.star, color: Colors.amber, size: 16),
              const SizedBox(width: 4),
              Text(
                '${product.averageRating.toStringAsFixed(1)} (${product.reviewCount})',
                style: TextStyle(color: Colors.grey[700]),
              ),
            ],
          ),
        ),

        // 6. Hành động
        Expanded(
          flex: 1,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Tooltip(
                message: 'Chỉnh sửa',
                child: IconButton(
                  icon: Icon(Icons.edit_outlined, color: Colors.blue[600]),
                  onPressed: onEdit,
                ),
              ),
              Tooltip(
                message: 'Xóa sản phẩm',
                child: IconButton(
                  icon: Icon(Icons.delete_outlined, color: Colors.red[600]),
                  onPressed: onDelete,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Helper cho chip hiển thị trạng thái
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
