import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_core/shop_core.dart'; // Để dùng SnackbarUtils
import '../bloc/banner/banner_admin_bloc.dart';
import '../bloc/banner/banner_admin_event.dart';
import 'custom_text_field.dart';

class AddBannerDialog extends StatefulWidget {
  const AddBannerDialog({super.key});

  @override
  State<AddBannerDialog> createState() => _AddBannerDialogState();
}

class _AddBannerDialogState extends State<AddBannerDialog> {
  final _formKey = GlobalKey<FormState>();
  final _imageUrlController = TextEditingController();
  final _orderController = TextEditingController(text: '1');
  final _targetIdController = TextEditingController();
  String _targetType = 'none';

  @override
  void dispose() {
    _imageUrlController.dispose();
    _orderController.dispose();
    _targetIdController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_imageUrlController.text.isEmpty) {
      SnackbarUtils.showError(context, 'Vui lòng nhập URL hình ảnh', null);
      return;
    }

    // Gửi sự kiện AddBanner tới Bloc
    context.read<BannerAdminBloc>().add(
      AddBanner(
        imageUrl: _imageUrlController.text.trim(),
        order: int.tryParse(_orderController.text) ?? 0,
        targetType: _targetType,
        targetId: _targetIdController.text.trim(),
      ),
    );

    Navigator.of(context).pop();
    SnackbarUtils.showSuccess(context, 'Đang thêm banner...', null);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Thêm Banner Quảng Cáo'),
      content: SizedBox(
        width: 500,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomTextField(
                  controller: _imageUrlController,
                  labelText: 'URL Hình ảnh (*)',
                  icon: const Icon(Icons.image),
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _orderController,
                  labelText: 'Thứ tự hiển thị',
                  icon: const Icon(Icons.sort),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _targetType,
                  decoration: const InputDecoration(
                    labelText: 'Loại điều hướng',
                    prefixIcon: Icon(Icons.link),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'none', child: Text('Không có')),
                    DropdownMenuItem(value: 'product', child: Text('Sản phẩm')),
                    DropdownMenuItem(
                      value: 'category',
                      child: Text('Danh mục'),
                    ),
                  ],
                  onChanged: (value) => setState(() => _targetType = value!),
                ),
                if (_targetType != 'none') ...[
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _targetIdController,
                    labelText: 'ID Mục tiêu (Product/Category ID)',
                    icon: const Icon(Icons.key),
                  ),
                ],
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
        ElevatedButton(onPressed: _submitForm, child: const Text('Xác nhận')),
      ],
    );
  }
}
