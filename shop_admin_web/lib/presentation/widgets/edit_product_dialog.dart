import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_core/shop_core.dart';
import '../bloc/products/products_admin_bloc.dart';
import '../bloc/products/products_admin_event.dart';

class EditProductDialog extends StatefulWidget {
  final Product product;

  const EditProductDialog({super.key, required this.product});

  @override
  State<EditProductDialog> createState() => _EditProductDialogState();
}

class _EditProductDialogState extends State<EditProductDialog> {
  final _formKey = GlobalKey<FormState>();

  // Controllers cho tên sản phẩm
  late TextEditingController _nameViController;
  late TextEditingController _nameEnController;
  late TextEditingController _nameJaController;

  // Controllers cho mô tả
  late TextEditingController _descViController;
  late TextEditingController _descEnController;
  late TextEditingController _descJaController;

  // Các thông số khác
  late TextEditingController _priceController;
  late TextEditingController _imageUrlController;
  late String _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    // Khởi tạo giá trị từ sản phẩm cũ
    _nameViController = TextEditingController(
      text: widget.product.name['vi'] ?? '',
    );
    _nameEnController = TextEditingController(
      text: widget.product.name['en'] ?? '',
    );
    _nameJaController = TextEditingController(
      text: widget.product.name['ja'] ?? '',
    );

    _descViController = TextEditingController(
      text: widget.product.description['vi'] ?? '',
    );
    _descEnController = TextEditingController(
      text: widget.product.description['en'] ?? '',
    );
    _descJaController = TextEditingController(
      text: widget.product.description['ja'] ?? '',
    );

    _priceController = TextEditingController(
      text: widget.product.price.toString(),
    );
    _imageUrlController = TextEditingController(text: widget.product.imageUrl);
    _selectedCategoryId = widget.product.categoryId;
  }

  @override
  void dispose() {
    // Giải phóng bộ nhớ cho các controller
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
    if (_formKey.currentState!.validate()) {
      // Gửi sự kiện cập nhật đầy đủ 3 ngôn ngữ tới Bloc
      context.read<ProductsAdminBloc>().add(
        UpdateProducts(
          productId: widget.product.id,
          name: {
            'vi': _nameViController.text.trim(),
            'en': _nameEnController.text.trim(),
            'ja': _nameJaController.text.trim(),
          },
          price: int.parse(_priceController.text.trim()),
          description: {
            'vi': _descViController.text.trim(),
            'en': _descEnController.text.trim(),
            'ja': _descJaController.text.trim(),
          },
          imageUrl: _imageUrlController.text.trim(),
          categoryId: _selectedCategoryId,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.edit, color: Colors.blue),
          SizedBox(width: 10),
          Text('Chỉnh sửa sản phẩm'),
        ],
      ),
      content: SizedBox(
        width: 600, // Độ rộng vừa đủ cho màn hình Admin Web
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tên sản phẩm',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const Divider(),
                TextFormField(
                  controller: _nameViController,
                  decoration: const InputDecoration(
                    labelText: 'Tiếng Việt',
                    prefixIcon: Icon(Icons.language),
                  ),
                  validator:
                      (value) => value!.isEmpty ? 'Vui lòng nhập tên TV' : null,
                ),
                TextFormField(
                  controller: _nameEnController,
                  decoration: const InputDecoration(
                    labelText: 'Tiếng Anh',
                    prefixIcon: Icon(Icons.language),
                  ),
                ),
                TextFormField(
                  controller: _nameJaController,
                  decoration: const InputDecoration(
                    labelText: 'Tiếng Nhật',
                    prefixIcon: Icon(Icons.language),
                  ),
                ),
                const SizedBox(height: 20),

                const Text(
                  'Thông tin chung',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const Divider(),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _priceController,
                        decoration: const InputDecoration(
                          labelText: 'Giá sản phẩm',
                          prefixIcon: Icon(Icons.attach_money),
                        ),
                        keyboardType: TextInputType.number,
                        validator:
                            (value) =>
                                value!.isEmpty ? 'Vui lòng nhập giá' : null,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: TextFormField(
                        controller: _imageUrlController,
                        decoration: const InputDecoration(
                          labelText: 'URL Hình ảnh',
                          prefixIcon: Icon(Icons.image),
                        ),
                        validator:
                            (value) =>
                                value!.isEmpty ? 'Vui lòng nhập URL ảnh' : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                const Text(
                  'Mô tả sản phẩm',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const Divider(),
                TextFormField(
                  controller: _descViController,
                  decoration: const InputDecoration(
                    labelText: 'Mô tả (Tiếng Việt)',
                    alignLabelWithHint: true,
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _descEnController,
                  decoration: const InputDecoration(
                    labelText: 'Mô tả (Tiếng Anh)',
                    alignLabelWithHint: true,
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _descJaController,
                  decoration: const InputDecoration(
                    labelText: 'Mô tả (Tiếng Nhật)',
                    alignLabelWithHint: true,
                  ),
                  maxLines: 2,
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Hủy'),
        ),
        ElevatedButton(
          onPressed: _submitForm,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          ),
          child: const Text(
            'Cập nhật sản phẩm',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
