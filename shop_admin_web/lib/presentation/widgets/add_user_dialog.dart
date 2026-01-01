import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_core/shop_core.dart';
import 'package:shop_admin_web/presentation/widgets/custom_text_field.dart';
import '../bloc/users/users_admin_bloc.dart';
import '../bloc/users/users_admin_event.dart';

class AddUserDialog extends StatefulWidget {
  const AddUserDialog({super.key});

  @override
  State<AddUserDialog> createState() => _AddUserDialogState();
}

class _AddUserDialogState extends State<AddUserDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _selectedRole = 'user';

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty) {
      SnackbarUtils.showError(
        context,
        'Vui lòng nhập đầy đủ thông tin (*)',
        null,
      );
      return;
    }

    context.read<UsersAdminBloc>().add(
      AddUser(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        role: _selectedRole,
        password: _passwordController.text.trim(),
      ),
    );

    Navigator.of(context).pop();
    SnackbarUtils.showSuccess(context, 'Đang thêm người dùng...', null);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Thêm Người Dùng Mới'),
      content: SizedBox(
        width: 500,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  value: _selectedRole,
                  decoration: const InputDecoration(
                    labelText: 'Vai trò hệ thống',
                    prefixIcon: Icon(Icons.security),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'user', child: Text('Người dùng')),
                    DropdownMenuItem(
                      value: 'admin',
                      child: Text('Quản trị viên'),
                    ),
                  ],
                  onChanged: (value) => setState(() => _selectedRole = value!),
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _nameController,
                  labelText: 'Họ và tên (*)',
                  icon: const Icon(Icons.person),
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _emailController,
                  labelText: 'Địa chỉ Email (*)',
                  icon: const Icon(Icons.email),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _passwordController,
                  labelText: 'Mật khẩu khởi tạo (*)',
                  icon: const Icon(Icons.lock_outline),
                  obscureText: true,
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Hủy'),
        ),
        ElevatedButton(
          onPressed: _submitForm,
          child: const Text('Xác nhận thêm'),
        ),
      ],
    );
  }
}
