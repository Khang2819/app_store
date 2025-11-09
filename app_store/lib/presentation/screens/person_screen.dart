import 'package:bloc_app/presentation/widgets/home_appbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/app_localizations.dart';
import '../bloc/auth/auth_bloc.dart';
import '../bloc/auth/auth_even.dart';
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
    return Scaffold(
      appBar: HomeAppbar(title: language.person),
      backgroundColor: Color(0xffFFF8F0),
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
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Có lỗi xảy ra',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.white,
                        backgroundImage:
                            (user?.photoURL != null)
                                ? NetworkImage(user!.photoURL!)
                                : null,
                        child:
                            (user?.photoURL == null)
                                ? Icon(Icons.person, size: 60)
                                : null,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user?.displayName ?? 'Không có tên',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(user?.email ?? 'Không có email'),
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
                              ListTile(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(12),
                                  ),
                                ),
                                tileColor: Colors.white,
                                leading: Icon(Icons.history),
                                title: Text('Lịch sử đơn hàng'),
                                trailing: Icon(
                                  Icons.arrow_forward_ios,
                                  size: 16,
                                ),
                                onTap: () {},
                              ),
                              Divider(height: 1, indent: 16, endIndent: 16),
                              ListTile(
                                leading: Icon(Icons.favorite_border),
                                title: Text('Yêu thích'),
                                trailing: Icon(
                                  Icons.arrow_forward_ios,
                                  size: 16,
                                ),
                                onTap: () {
                                  context.push('/favorites');
                                },
                              ),
                              Divider(height: 1, indent: 16, endIndent: 16),
                              LanguageSettingTile(),
                              Divider(height: 1, indent: 16, endIndent: 16),
                              ListTile(
                                leading: Icon(Icons.edit_note),
                                title: Text('Chỉnh sửa thông tin'),
                                trailing: Icon(
                                  Icons.arrow_forward_ios,
                                  size: 16,
                                ),
                                onTap: () {
                                  context.push('/edit-profile');
                                },
                              ),
                              Divider(height: 1, indent: 16, endIndent: 16),
                              ListTile(
                                tileColor: Colors.white,
                                leading: Icon(Icons.help_outline),
                                title: Text('Trung tâm trợ giúp'),
                                trailing: Icon(
                                  Icons.arrow_forward_ios,
                                  size: 16,
                                ),
                                onTap: () {},
                              ),
                              Divider(height: 1, indent: 16, endIndent: 16),
                              ListTile(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                    bottom: Radius.circular(12),
                                  ),
                                ),
                                tileColor: Colors.white,
                                leading: Icon(Icons.logout, color: Colors.red),
                                title: Text(
                                  'Đăng xuất',
                                  style: TextStyle(color: Colors.red),
                                ),
                                onTap: () {
                                  AppDialog.showConfirmDialog(
                                    context,
                                    title: 'Xác nhận',
                                    message:
                                        'Bạn có chắc muốn đăng xuất không?',
                                    onConfirm: () {
                                      context.read<AuthBloc>().add(Logout());
                                      context.read<NavigationBloc>().add(
                                        NavigationReset(),
                                      );
                                      context.read<CartBloc>().add(ClearCart());
                                      context.go('/login');
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
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
