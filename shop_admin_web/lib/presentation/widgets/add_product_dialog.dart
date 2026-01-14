// lib/presentation/widgets/add_product_dialog.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_core/shop_core.dart';
import 'package:shop_admin_web/presentation/widgets/custom_text_field.dart';

import '../bloc/products/products_admin_bloc.dart';
import '../bloc/products/products_admin_event.dart';
// [IMPORT MỚI] Import Bloc và Event của Category
import '../bloc/category/category_admin_bloc.dart';
import '../bloc/category/category_admin_state.dart';
import '../bloc/category/category_admin_event.dart';

class AddProductDialog extends StatefulWidget {
  const AddProductDialog({super.key});

  @override
  State<AddProductDialog> createState() => _AddProductDialogState();
}

class _AddProductDialogState extends State<AddProductDialog> {
  final _formKey = GlobalKey<FormState>();

  final _nameViController = TextEditingController();
  final _nameEnController = TextEditingController();
  final _nameJaController = TextEditingController();
  final _descViController = TextEditingController();
  final _descEnController = TextEditingController();
  final _descJaController = TextEditingController();
  final _priceController = TextEditingController();
  final _imageUrlController = TextEditingController();

  // [SỬA ĐỔI] Khởi tạo null để bắt buộc người dùng chọn
  String? _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    // [THÊM MỚI] Tải danh sách danh mục ngay khi mở Dialog
    // Đảm bảo CategoryAdminBloc đã được provide ở màn hình cha (hoặc main.dart)
    context.read<CategoryAdminBloc>().add(LoadCategories());
  }

  @override
  void dispose() {
    _nameViController.dispose();
    _nameEnController.dispose();
    _nameJaController.dispose();
    _descViController.dispose();
    _descEnController.dispose();
    _descJaController.dispose();
    _priceController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _submitForm() {
    // Validate form
    if (_formKey.currentState?.validate() != true) {
      return;
    }

    // Kiểm tra thủ công nếu validator của TextField chưa đủ
    if (_nameViController.text.isEmpty || _priceController.text.isEmpty) {
      SnackbarUtils.showError(
        context,
        'Vui lòng nhập đầy đủ Tên (VN) và Giá.',
        null,
      );
      return;
    }

    if (_selectedCategoryId == null) {
      SnackbarUtils.showError(context, 'Vui lòng chọn danh mục.', null);
      return;
    }

    final names = {
      'vi': _nameViController.text.trim(),
      'en': _nameEnController.text.trim(),
      'ja': _nameJaController.text.trim(),
    };
    final descriptions = {
      'vi': _descViController.text.trim(),
      'en': _descEnController.text.trim(),
      'ja': _descJaController.text.trim(),
    };

    final price = int.tryParse(_priceController.text.trim()) ?? 0;

    context.read<ProductsAdminBloc>().add(
      AddProduct(
        names: names,
        imageUrl: _imageUrlController.text.trim(),
        price: price,
        descriptions: descriptions,
        // [SỬA ĐỔI] Truyền ID thật của danh mục đã chọn
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
        width: 600,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // [THAY THẾ] DropdownButtonFormField bằng BlocBuilder để lấy dữ liệu thật
                BlocBuilder<CategoryAdminBloc, CategoryAdminState>(
                  builder: (context, state) {
                    // Nếu đang tải danh mục
                    if (state.isLoading && state.categories.isEmpty) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    // Map danh sách danh mục từ Bloc ra DropdownMenuItem
                    final categoryItems =
                        state.categories.map((category) {
                          // Lấy tên tiếng Việt, nếu không có thì lấy tên đầu tiên hoặc báo lỗi
                          final name = category.name['vi'] ?? 'Chưa có tên';
                          return DropdownMenuItem<String>(
                            value:
                                category.id, // Giá trị là ID thật từ Firestore
                            child: Text(name),
                          );
                        }).toList();

                    return DropdownButtonFormField<String>(
                      value: _selectedCategoryId,
                      decoration: const InputDecoration(
                        labelText: 'Danh mục (*)',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.category),
                      ),
                      items: categoryItems,
                      onChanged: (value) {
                        setState(() {
                          _selectedCategoryId = value;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng chọn danh mục';
                        }
                        return null;
                      },
                      hint: const Text('Chọn danh mục sản phẩm'),
                    );
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
                  labelText: 'Description (Japan)',
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
