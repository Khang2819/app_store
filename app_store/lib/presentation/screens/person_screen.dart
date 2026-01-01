import 'package:bloc_app/presentation/widgets/home_appbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shop_core/l10n/app_localizations.dart';

import '../bloc/auth/auth_bloc.dart';
import '../bloc/auth/auth_even.dart';
import '../bloc/auth/auth_state.dart'; // Đảm bảo import đúng AuthState
import '../bloc/cart/cart_bloc.dart';
import '../bloc/cart/cart_event.dart';
import '../bloc/navigation/navigation_bloc.dart';
import '../bloc/navigation/navigation_event.dart';
import '../bloc/profile/profile_bloc.dart';
import '../bloc/profile/profile_event.dart';
import '../bloc/profile/profile_state.dart';
import '../widgets/language_setting_tile.dart';
import '../widgets/showdialog.dart';

class PersonScreen extends StatefulWidget {
  const PersonScreen({super.key});

  @override
  State<PersonScreen> createState() => _PersonScreenState();
}

class _PersonScreenState extends State<PersonScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(LoadProfile());
  }

  @override
  Widget build(BuildContext context) {
    final language = AppLocalizations.of(context)!;
    final user = FirebaseAuth.instance.currentUser;

    // SỬA TẠI ĐÂY: Sử dụng BlocListener để bắt trạng thái đăng xuất thành công
    return BlocListener<AuthBloc, AuthState>(
      listenWhen:
          (previous, current) => previous.isSuccess != current.isSuccess,
      listener: (context, state) {
        if (state.isSuccess) {
          // 1. Dọn dẹp các dữ liệu khác
          context.read<NavigationBloc>().add(NavigationReset());
          context.read<CartBloc>().add(ClearCart());

          // 2. Chuyển hướng về trang Login
          context.go('/login');

          // 3. Reset trạng thái AuthBloc để không bị lặp lại logic khi quay lại
          context.read<AuthBloc>().add(ClearAuthStatus());
        }
      },
      child: Scaffold(
        appBar: HomeAppbar(title: language.person),
        backgroundColor: const Color(0xffFFF8F0),
        body: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(
                child: CircularProgressIndicator(color: Color(0xff2A4ECA)),
              );
            }

            if (state.error != null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Có lỗi xảy ra',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.error!,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        context.read<ProfileBloc>().add(LoadProfile());
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Thử lại'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff2A4ECA),
                      ),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<ProfileBloc>().add(LoadProfile());
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white,
                      backgroundImage:
                          (user?.photoURL != null)
                              ? NetworkImage(user!.photoURL!)
                              : null,
                      child:
                          (user?.photoURL == null)
                              ? const Icon(Icons.person, size: 60)
                              : null,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      user?.displayName ?? 'Không có tên',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user?.email ?? 'Không có email',
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Card(
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            _buildListTile(
                              icon: Icons.history,
                              title: 'Lịch sử đơn hàng',
                              onTap: () => context.push('/order-history'),
                              isFirst: true,
                            ),
                            const Divider(height: 1, indent: 16, endIndent: 16),
                            _buildListTile(
                              icon: Icons.favorite_border,
                              title: 'Yêu thích',
                              onTap: () => context.push('/favorites'),
                            ),
                            const Divider(height: 1, indent: 16, endIndent: 16),
                            const LanguageSettingTile(),
                            const Divider(height: 1, indent: 16, endIndent: 16),
                            _buildListTile(
                              icon: Icons.edit_note,
                              title: 'Chỉnh sửa thông tin',
                              onTap: () => context.push('/edit-profile'),
                            ),
                            const Divider(height: 1, indent: 16, endIndent: 16),
                            _buildListTile(
                              icon: Icons.help_outline,
                              title: 'Trung tâm trợ giúp',
                              onTap: () {},
                            ),
                            const Divider(height: 1, indent: 16, endIndent: 16),
                            // NÚT ĐĂNG XUẤT ĐÃ SỬA LOGIC
                            ListTile(
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  bottom: Radius.circular(12),
                                ),
                              ),
                              tileColor: Colors.white,
                              leading: const Icon(
                                Icons.logout,
                                color: Colors.red,
                              ),
                              title: const Text(
                                'Đăng xuất',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onTap: () {
                                AppDialog.showConfirmDialog(
                                  context,
                                  title: 'Xác nhận',
                                  message: 'Bạn có chắc muốn đăng xuất không?',
                                  onConfirm: () {
                                    // CHỈ GỬI EVENT LOGOUT, listener bên trên sẽ lo việc điều hướng
                                    context.read<AuthBloc>().add(Logout());
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // Widget phụ trợ để code gọn hơn
  Widget _buildListTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isFirst = false,
  }) {
    return ListTile(
      shape:
          isFirst
              ? const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              )
              : null,
      tileColor: Colors.white,
      leading: Icon(icon, color: const Color(0xff8B5E3C)),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 14),
      onTap: onTap,
    );
  }
}
