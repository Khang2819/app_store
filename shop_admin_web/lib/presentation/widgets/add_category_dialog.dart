import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/category/category_admin_bloc.dart';
import '../bloc/category/category_admin_event.dart';
import 'custom_text_field.dart';

class AddCategoryDialog extends StatefulWidget {
  const AddCategoryDialog({super.key});
  @override
  State<AddCategoryDialog> createState() => _AddCategoryDialogState();
}

class _AddCategoryDialogState extends State<AddCategoryDialog> {
  final _nameViController = TextEditingController();
  final _imageUrlController = TextEditingController();

  void _submit() {
    if (_nameViController.text.isEmpty) return;

    context.read<CategoryAdminBloc>().add(
      AddCategory(
        names: {'vi': _nameViController.text.trim()},
        imageUrl: _imageUrlController.text.trim(),
      ),
      // Lưu ý: CategoryAdminBloc của bạn hiện tại cần cập nhật để nhận thêm imageUrl nếu cần
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Thêm Danh Mục Mới'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomTextField(
            controller: _nameViController,
            labelText: 'Tên danh mục (VN)',
            icon: const Icon(Icons.category),
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: _imageUrlController,
            labelText: 'URL Hình ảnh',
            icon: const Icon(Icons.image),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Hủy'),
        ),
        ElevatedButton(onPressed: _submit, child: const Text('Thêm')),
      ],
    );
  }
}
