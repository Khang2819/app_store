import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_core/models/category_model.dart'; // Đảm bảo đúng path tới model của bạn
import '../bloc/category/category_admin_bloc.dart';
import '../bloc/category/category_admin_event.dart';
import 'custom_text_field.dart';

class EditCategoryDialog extends StatefulWidget {
  final Category category;

  const EditCategoryDialog({super.key, required this.category});

  @override
  State<EditCategoryDialog> createState() => _EditCategoryDialogState();
}

class _EditCategoryDialogState extends State<EditCategoryDialog> {
  late TextEditingController _nameViController;
  late TextEditingController _imageUrlController;

  @override
  void initState() {
    super.initState();
    // Lấy dữ liệu cũ đổ vào Controller
    _nameViController = TextEditingController(
      text: widget.category.name['vi'] ?? '',
    );
    _imageUrlController = TextEditingController(text: widget.category.imageUrl);
  }

  @override
  void dispose() {
    _nameViController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_nameViController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập tên danh mục')),
      );
      return;
    }

    // Gửi sự kiện UpdateCategory đã định nghĩa trong Bloc
    context.read<CategoryAdminBloc>().add(
      UpdateCategory(widget.category.id, {
        'vi': _nameViController.text.trim(),
      }, _imageUrlController.text.trim()),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.edit_note, color: Colors.orange[800]),
          const SizedBox(width: 10),
          const Text('Chỉnh sửa Danh mục'),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextField(
              controller: _nameViController,
              labelText: 'Tên danh mục (Tiếng Việt)',
              icon: const Icon(Icons.label_important_outline),
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _imageUrlController,
              labelText: 'Link hình ảnh (URL)',
              icon: const Icon(Icons.image_search),
            ),
            // if (_imageUrlController.text.isNotEmpty)
            //   Padding(
            //     padding: const EdgeInsets.only(top: 10),
            //     child: Image.network(
            //       _imageUrlController.text,
            //       height: 100,
            //       errorBuilder:
            //           (context, error, stackTrace) =>
            //               const Icon(Icons.broken_image, size: 50),
            //     ),
            //   ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Hủy'),
        ),
        ElevatedButton(
          onPressed: _submit,
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
          child: const Text('Cập nhật', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
