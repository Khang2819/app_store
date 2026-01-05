import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_core/shop_core.dart'; // Để dùng SnackbarUtils
import '../bloc/banner/banner_admin_bloc.dart';
import '../bloc/banner/banner_admin_event.dart';
import 'custom_text_field.dart';

class AddBannerDialog extends StatefulWidget {
  final BannerModel? banner; // Nhận banner nếu là chế độ chỉnh sửa
  const AddBannerDialog({super.key, this.banner});

  @override
  State<AddBannerDialog> createState() => _AddBannerDialogState();
}

class _AddBannerDialogState extends State<AddBannerDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _imageUrlController;
  late TextEditingController _orderController;
  late TextEditingController _targetIdController;
  String _targetType = 'none';

  @override
  void initState() {
    super.initState();
    // Bước 1: Khởi tạo giá trị ban đầu dựa trên việc có banner truyền vào hay không
    _imageUrlController = TextEditingController(
      text: widget.banner?.imageUrl ?? '',
    );
    _orderController = TextEditingController(
      text: widget.banner?.order.toString() ?? '1',
    );
    _targetIdController = TextEditingController(
      text: widget.banner?.targetId ?? '',
    );
    _targetType = widget.banner?.targetType ?? 'none';
  }

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

    final imageUrl = _imageUrlController.text.trim();
    final order = int.tryParse(_orderController.text) ?? 0;
    final targetId = _targetIdController.text.trim();

    // Bước 2: Phân loại logic Thêm mới hoặc Cập nhật
    if (widget.banner == null) {
      // Gửi sự kiện AddBanner
      context.read<BannerAdminBloc>().add(
        AddBanner(
          imageUrl: imageUrl,
          order: order,
          targetType: _targetType,
          targetId: targetId,
        ),
      );
      SnackbarUtils.showSuccess(context, 'Đang thêm banner...', null);
    } else {
      // Gửi sự kiện UpdateBanner
      context.read<BannerAdminBloc>().add(
        UpdateBanner(
          bannerId: widget.banner!.id, // Lấy ID từ banner cũ
          imageUrl: imageUrl,
          order: order,
          targetType: _targetType,
          targetId: targetId,
        ),
      );
      SnackbarUtils.showSuccess(context, 'Đang cập nhật banner...', null);
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    // Bước 3: Đổi tiêu đề linh hoạt
    final isEdit = widget.banner != null;

    return AlertDialog(
      title: Text(isEdit ? 'Chỉnh Sửa Banner' : 'Thêm Banner Quảng Cáo'),
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
        ElevatedButton(
          onPressed: _submitForm,
          child: Text(isEdit ? 'Lưu thay đổi' : 'Xác nhận'),
        ),
      ],
    );
  }
}
