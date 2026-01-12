import 'package:flutter/material.dart';
import 'package:shop_core/shop_core.dart'; // Đảm bảo Category model được import

class CategoryTableRow extends StatelessWidget {
  final Category category;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const CategoryTableRow({
    super.key,
    required this.category,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    // Lấy tên tiếng Việt hoặc tên đầu tiên có sẵn
    final categoryName = category.name['vi'] ?? category.name.values.first;

    return Row(
      children: [
        // 1. Hình ảnh
        Expanded(
          flex: 2,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child:
                category.imageUrl.isNotEmpty
                    ? Image.network(
                      category.imageUrl,
                      height: 200,
                      width: 60,
                      fit: BoxFit.cover,
                    )
                    : Container(
                      height: 200,
                      color: Colors.grey[200],
                      child: const Icon(Icons.image),
                    ),
          ),
        ),

        // 2. Tên danh mục
        Expanded(
          flex: 2,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              categoryName,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
            ),
          ),
        ),

        // 3. Trạng thái (Giả định luôn hoạt động)
        Expanded(
          flex: 1,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              // ignore: deprecated_member_use
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Text(
              'Hoạt động',
              style: TextStyle(color: Colors.green, fontSize: 12),
            ),
          ),
        ),

        // 4. Hành động
        Expanded(
          flex: 1,
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.edit_outlined, color: Colors.blue),
                onPressed: onEdit,
              ),
              IconButton(
                icon: const Icon(Icons.delete_outlined, color: Colors.red),
                onPressed: onDelete,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
