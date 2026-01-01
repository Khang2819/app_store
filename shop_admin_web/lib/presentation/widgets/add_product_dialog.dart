// lib/presentation/widgets/add_product_dialog.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_core/shop_core.dart';
import 'package:shop_admin_web/presentation/widgets/custom_text_field.dart';

import '../bloc/products/products_admin_bloc.dart';
import '../bloc/products/products_admin_event.dart';

class AddProductDialog extends StatefulWidget {
  const AddProductDialog({super.key});

  @override
  State<AddProductDialog> createState() => _AddProductDialogState();
}

class _AddProductDialogState extends State<AddProductDialog> {
  final _formKey = GlobalKey<FormState>();

  final _nameViController = TextEditingController();
  final _nameEnController = TextEditingController();
  final _nameJaController =
      TextEditingController(); // THÊM MỚI: Controller tiếng Nhật
  final _descViController = TextEditingController();
  final _descEnController = TextEditingController();
  final _descJaController = TextEditingController();
  final _priceController = TextEditingController();
  final _imageUrlController = TextEditingController();

  // Tạm thời hardcode Category ID vì chưa có Bloc quản lý Category
  String? _selectedCategoryId = 'placeholder_category_1';

  @override
  void dispose() {
    _nameViController.dispose();
    _nameEnController.dispose();
    _nameJaController.dispose(); // THÊM MỚI
    _descViController.dispose();
    _descEnController.dispose();
    _descJaController.dispose();
    _priceController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _submitForm() {
    // Vài logic kiểm tra đơn giản, bạn nên sử dụng validator trong CustomTextField
    if (_nameViController.text.isEmpty || _priceController.text.isEmpty) {
      SnackbarUtils.showError(
        context,
        'Vui lòng nhập đầy đủ Tên (VN) và Giá.',
        null,
      );
      return;
    }

    final names = {
      'vi': _nameViController.text.trim(),
      'en': _nameEnController.text.trim(),
      'ja': _nameJaController.text.trim(), // ĐÃ THÊM: Tiếng Nhật
    };
    final descriptions = {
      'vi': _descViController.text.trim(),
      'en': _descEnController.text.trim(),
      'ja': _descJaController.text.trim(),
    };

    final price = int.tryParse(_priceController.text.trim()) ?? 0;

    if (_selectedCategoryId == null) {
      SnackbarUtils.showError(context, 'Vui lòng chọn danh mục.', null);
      return;
    }

    context.read<ProductsAdminBloc>().add(
      AddProduct(
        names: names,
        imageUrl: _imageUrlController.text.trim(),
        price: price,
        descriptions: descriptions,
        categoryId: _selectedCategoryId!,
      ),
    );

    Navigator.of(context).pop();
    SnackbarUtils.showSuccess(context, 'Đang thêm sản phẩm...', null);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Thêm Sản Phẩm Mới'),
      content: SizedBox(
        width: 600, // Cố định chiều rộng cho form desktop
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Category Dropdown - Hardcoded categories (Cần thay bằng fetchCategories() thực tế)
                DropdownButtonFormField<String>(
                  value: _selectedCategoryId,
                  decoration: const InputDecoration(
                    labelText: 'Danh mục (Placeholder)',
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'placeholder_category_1',
                      child: Text('Đồ ăn'),
                    ),
                    DropdownMenuItem(
                      value: 'placeholder_category_2',
                      child: Text('Đồ uống'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedCategoryId = value;
                    });
                  },
                ),
                const SizedBox(height: 16),

                // Tên sản phẩm đa ngôn ngữ
                const Text(
                  'Tên sản phẩm',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                CustomTextField(
                  controller: _nameViController,
                  labelText: 'Tiếng Việt (*)',
                  icon: const Icon(Icons.flag),
                ),
                const SizedBox(height: 8),
                CustomTextField(
                  controller: _nameEnController,
                  labelText: 'Tiếng Anh',
                  icon: const Icon(Icons.flag_outlined),
                ),
                const SizedBox(height: 8),
                CustomTextField(
                  // ĐÃ THÊM: Tiếng Nhật
                  controller: _nameJaController,
                  labelText: 'Tiếng Nhật',
                  icon: const Icon(Icons.flag_circle_outlined),
                ),
                const SizedBox(height: 16),

                // Giá và URL
                CustomTextField(
                  controller: _priceController,
                  labelText: 'Giá (Đơn vị: ₫) (*)',
                  icon: const Icon(Icons.attach_money),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _imageUrlController,
                  labelText: 'URL Hình ảnh',
                  icon: const Icon(Icons.image),
                ),
                const SizedBox(height: 16),

                // Mô tả đa ngôn ngữ
                const Text(
                  'Mô tả sản phẩm',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                CustomTextField(
                  controller: _descViController,
                  labelText: 'Mô tả (Tiếng Việt)',
                  icon: const Icon(Icons.description),
                ),
                const SizedBox(height: 8),
                CustomTextField(
                  controller: _descEnController,
                  labelText: 'Description (English)',
                  icon: const Icon(Icons.description_outlined),
                ),
                const SizedBox(height: 8),
                CustomTextField(
                  controller: _descJaController,
                  labelText: 'Description (Janpan)',
                  icon: const Icon(Icons.description_outlined),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Hủy'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        ElevatedButton(onPressed: _submitForm, child: const Text('Thêm')),
      ],
    );
  }
}
