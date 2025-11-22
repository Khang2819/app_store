// lib/presentation/screens/edit_profile_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:shop_core/l10n/app_localizations.dart';
import 'package:shop_core/shop_core.dart';

import '../bloc/profile/profile_bloc.dart';
import '../bloc/profile/profile_event.dart';
import '../bloc/profile/profile_state.dart';
import '../widgets/textfile.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  bool _isPickingImage = false;

  @override
  void initState() {
    super.initState();
    // Khởi tạo tên từ trạng thái hiện tại của BLoC
    final currentState = context.read<ProfileBloc>().state;
    _nameController.text = currentState.user?.displayName ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    // THAY ĐỔI START: Ngăn chặn nếu đang chọn ảnh
    if (_isPickingImage) return;

    _isPickingImage = true; // Đặt cờ là đang chọn ảnh
    XFile? image;

    try {
      image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 50, // Giảm chất lượng để tăng tốc độ tải lên
      );
    } catch (e) {
      image = null;
    } finally {
      _isPickingImage = false; // Luôn reset cờ sau khi hoàn thành/lỗi
    }
    // THAY ĐỔI END
    if (!mounted) return;
    if (image != null) {
      context.read<ProfileBloc>().add(UploadAvatar(imageFile: image));
    }
  }

  void _updateName() {
    final newName = _nameController.text.trim();
    if (newName.isEmpty) {
      // Có thể thêm validation nếu cần
      return;
    }
    context.read<ProfileBloc>().add(UpdateProfile(name: newName));
  }

  @override
  Widget build(BuildContext context) {
    final language = AppLocalizations.of(context)!;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Chỉnh sửa thông tin'),
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => context.pop(),
          ),
        ),
        body: BlocConsumer<ProfileBloc, ProfileState>(
          listenWhen:
              (p, c) => p.isLoading != c.isLoading || p.error != c.error,
          listener: (context, state) {
            if (state.isLoading) {
              context.loaderOverlay.show();
            } else {
              context.loaderOverlay.hide();
              if (state.error != null) {
                // Lấy thông báo lỗi từ AuthException nếu có
                final errorMessage =
                    state.error!.contains('AuthException')
                        ? state.error!.split(':').last.trim()
                        : language.unknown_error;

                SnackbarUtils.showError(context, errorMessage, language);
              } else if (state.user != null &&
                  state.user!.displayName == _nameController.text.trim()) {
                // Chỉ hiển thị thành công khi tên đã được cập nhật
                SnackbarUtils.showSuccess(
                  context,
                  'Cập nhật hồ sơ thành công!',
                  language,
                );
              }
            }
          },
          builder: (context, state) {
            final user = state.user;
            // Cập nhật textfield khi LoadProfile được gọi thành công (trừ lần đầu)
            if (!state.isLoading &&
                _nameController.text.isEmpty &&
                user != null) {
              _nameController.text = user.displayName ?? '';
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.grey[200],
                          backgroundImage:
                              (state.avatarUrl != null)
                                  ? NetworkImage(state.avatarUrl!)
                                  : null,
                          child:
                              (state.avatarUrl == null)
                                  ? const Icon(
                                    Icons.person,
                                    size: 70,
                                    color: Colors.grey,
                                  )
                                  : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: InkWell(
                            onTap: _pickImage,
                            child: CircleAvatar(
                              radius: 18,
                              backgroundColor: Theme.of(context).primaryColor,
                              child: const Icon(
                                Icons.camera_alt,
                                size: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  Textfile(
                    labelText: language.name,
                    icon: const Icon(Icons.person),
                    controller: _nameController,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Email: ${user?.email ?? 'N/A'}',
                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff2A4ECA),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: state.isLoading ? null : _updateName,
                    child: const Text(
                      'Lưu thay đổi',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
