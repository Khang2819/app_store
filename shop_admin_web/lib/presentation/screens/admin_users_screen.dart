import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_core/shop_core.dart';
import '../widgets/add_user_dialog.dart';
import '../widgets/tablerow.dart';
import '../bloc/users/users_admin_event.dart';

import '../bloc/users/users_admin_bloc.dart';
import '../bloc/users/users_admin_state.dart';
import '../widgets/admin_sidebar.dart';
import '../widgets/containerbox.dart';
import '../widgets/fiterchip.dart';
import '../widgets/header_admin.dart';
import '../widgets/search_admin.dart';
import '../widgets/wellcome.dart';

class AdminUsersScreen extends StatelessWidget {
  const AdminUsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 800;
        return isMobile
            ? _buildMobileLayout(context)
            : _buildDesktopLayout(context);
      },
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const AdminSidebar(isExpanded: true),
          Expanded(
            child: Column(
              children: [
                HeaderAdmin(),
                Expanded(
                  child: BlocBuilder<UsersAdminBloc, UsersAdminState>(
                    builder: (context, state) {
                      return UsersContext(isMobile: false);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Scaffold(
      drawer: const Drawer(child: AdminSidebar(isExpanded: true)),
      appBar: AppBar(title: const Text('Admin Dashboard')), // cái này
      body: BlocBuilder<UsersAdminBloc, UsersAdminState>(
        builder: (context, state) {
          return UsersContext(isMobile: true);
        },
      ),
    );
  }
}

class UsersContext extends StatelessWidget {
  final bool isMobile;
  const UsersContext({super.key, this.isMobile = false});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UsersAdminBloc, UsersAdminState>(
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                // ignore: deprecated_member_use
                Colors.blue.withOpacity(0.03),
                // ignore: deprecated_member_use
                Colors.purple.withOpacity(0.03),
              ],
            ),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wellcome(
                  title: 'Quản lý người dùng',
                  icon: Icons.people,
                  buttonIcon: Icons.add_circle_outline,
                  buttonText: 'Thêm người dùng',
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => const AddUserDialog(),
                    );
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Containerbox(
                        title: 'Tổng số tài khoản',
                        count: state.totalCount,
                        color: Colors.green,
                        icon: Icons.check_circle,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Containerbox(
                        title: 'Quản lý admin',
                        count: state.adminCount,
                        color: Colors.orange,
                        icon: Icons.access_time,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Containerbox(
                        title: 'Bị cấm',
                        count: state.bannedCount,
                        color: Colors.red,
                        icon: Icons.block,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        // ignore: deprecated_member_use
                        color: const Color(0xFF667eea).withOpacity(0.5),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: SearchAdmin(
                              text: 'Tìm kiếm theo tên, email...',
                              onChanged: (query) {
                                context.read<UsersAdminBloc>().add(
                                  SearchUsers(query),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          Fiterchip(
                            title: 'Tất cả',
                            value: 'all',
                            currentValue: state.filterStatus,
                            icon: Icons.apps,
                            onTap: () {
                              // Gọi sự kiện lọc trong BLoC
                              context.read<UsersAdminBloc>().add(
                                FilterUsers('all'),
                              );
                            },
                          ),
                          Fiterchip(
                            title: 'Người dùng',
                            value: 'user',
                            currentValue: state.filterStatus,
                            icon: Icons.check_circle,
                            onTap: () {
                              // THÊM: Gọi sự kiện lọc
                              context.read<UsersAdminBloc>().add(
                                const FilterUsers('user'),
                              );
                            },
                          ),
                          Fiterchip(
                            title: 'Quản trị viên',
                            value: 'admin',
                            currentValue: state.filterStatus,
                            icon: Icons.access_time,
                            onTap: () {
                              // THÊM: Gọi sự kiện lọc
                              context.read<UsersAdminBloc>().add(
                                const FilterUsers('admin'),
                              );
                            },
                          ),
                          Fiterchip(
                            title: 'Bị cấm',
                            value: 'banned',
                            currentValue: state.filterStatus,
                            icon: Icons.block,
                            onTap: () {
                              // THÊM: Gọi sự kiện lọc
                              context.read<UsersAdminBloc>().add(
                                const FilterUsers('banned'),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        // ignore: deprecated_member_use
                        color: const Color(0xFF667eea).withOpacity(0.5),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.grey[50]!, Colors.grey[100]!],
                          ),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: _buildHeaderCell(
                                'Người dùng',
                                Icons.person,
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: _buildHeaderCell('Email', Icons.email),
                            ),
                            Expanded(
                              flex: 1,
                              child: _buildHeaderCell(
                                'Đơn hàng',
                                Icons.receipt_long,
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: _buildHeaderCell('Vai trò', Icons.star),
                            ),
                            Expanded(
                              flex: 1,
                              child: _buildHeaderCell('Trạng thái', Icons.info),
                            ),
                            Expanded(
                              flex: 1,
                              child: _buildHeaderCell(
                                'Thời gian đăng kí',
                                Icons.schedule,
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: _buildHeaderCell(
                                'Hành động',
                                Icons.settings,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Hiển thị danh sách người dùng
                      _buildUserList(context, state),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeaderCell(String text, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  /// Xây dựng danh sách các hàng dữ liệu người dùng
  Widget _buildUserList(BuildContext context, UsersAdminState state) {
    if (state.isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (state.errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Text(
            'Lỗi: ${state.errorMessage}',
            style: const TextStyle(color: Colors.red),
          ),
        ),
      );
    }

    if (state.users.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: Text('Không tìm thấy người dùng nào.'),
        ),
      );
    }

    return Column(
      children: List.generate(state.users.length, (index) {
        final user = state.users[index];
        // Sử dụng TableRowItem để có animation
        return TableRowItem(
          index: index,
          totalUsers: state.users.length,
          // Truyền widget hàng người dùng vào child
          child: _buildUserRow(context, user),
        );
      }),
    );
  }

  /// Xây dựng một hàng dữ liệu người dùng
  Widget _buildUserRow(BuildContext context, UsersModels user) {
    // Format ngày đăng ký
    final createdAt = user.createdAt?.toDate();
    final dateString =
        createdAt != null
            ? '${createdAt.day}/${createdAt.month}/${createdAt.year}'
            : 'N/A';

    return Row(
      children: [
        // 1. Người dùng (Name)
        Expanded(
          flex: 2,
          child: Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundImage:
                    user.photoUrl != null ? NetworkImage(user.photoUrl!) : null,
                child:
                    user.photoUrl == null
                        ? Text(
                          user.name?.isNotEmpty == true
                              ? user.name![0].toUpperCase()
                              : 'U',
                          style: const TextStyle(color: Colors.white),
                        )
                        : null,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  user.name ?? 'No Name',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
        ),
        // 2. Email
        Expanded(
          flex: 2,
          child: Text(
            user.email ?? 'N/A',
            style: TextStyle(color: Colors.grey[600]),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        // 3. Đơn hàng (Placeholder count)
        Expanded(
          flex: 1,
          child: Text(
            user.role == 'admin' ? 'N/A' : '${user.orderCount}',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ),
        // 4. Vai trò (Role)
        Expanded(
          flex: 1,
          child: _buildChip(
            user.role == 'admin' ? 'Admin' : 'Người dùng',
            user.role == 'admin' ? Colors.indigo : Colors.blue,
          ),
        ),
        // 5. Trạng thái (Status) - Sử dụng 'banned' từ role
        Expanded(
          flex: 1,
          child: _buildChip(
            user.role == 'banned' ? 'Bị cấm' : 'Hoạt động',
            user.role == 'banned' ? Colors.red : Colors.green,
          ),
        ),
        // 6. Thời gian đăng kí (CreatedAt)
        Expanded(
          flex: 1,
          child: Text(dateString, style: TextStyle(color: Colors.grey[600])),
        ),
        // 7. Hành động (Actions)
        Expanded(
          flex: 1,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Edit/Change Role
              Tooltip(
                message: 'Thay đổi quyền',
                child: IconButton(
                  icon: Icon(Icons.edit_outlined, color: Colors.blue[600]),
                  onPressed: () => _showRoleDialog(context, user),
                ),
              ),
              // Delete User
              Tooltip(
                message: 'Xóa người dùng',
                child: IconButton(
                  icon: Icon(Icons.delete_outlined, color: Colors.red[600]),
                  onPressed: () => _confirmDelete(context, user),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Helper cho chip hiển thị vai trò/trạng thái
  Widget _buildChip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        // ignore: deprecated_member_use
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  /// Hiển thị Dialog để thay đổi vai trò
  void _showRoleDialog(BuildContext context, UsersModels user) {
    String? newRole = user.role;
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Cập nhật vai trò cho ${user.name}'),
          content: DropdownButtonFormField<String>(
            value: user.role,
            decoration: const InputDecoration(labelText: 'Vai trò'),
            items: const [
              DropdownMenuItem(value: 'user', child: Text('Người dùng')),
              DropdownMenuItem(value: 'admin', child: Text('Quản trị viên')),
              DropdownMenuItem(value: 'banned', child: Text('Bị cấm')),
            ],
            onChanged: (value) {
              newRole = value;
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () {
                if (newRole != null && newRole != user.role) {
                  // Gọi sự kiện Bloc để cập nhật
                  context.read<UsersAdminBloc>().add(
                    UpdateUsers(user.id, newRole!),
                  );
                  SnackbarUtils.showSuccess(
                    context,
                    'Đang cập nhật vai trò...',
                    null,
                  );
                }
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Cập nhật'),
            ),
          ],
        );
      },
    );
  }

  /// Hiển thị Dialog xác nhận xóa người dùng
  void _confirmDelete(BuildContext context, UsersModels user) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Xác nhận xóa'),
          content: Text(
            'Bạn có chắc chắn muốn xóa người dùng "${user.name}" không? Hành động này không thể hoàn tác.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                // Gọi sự kiện Bloc để xóa
                context.read<UsersAdminBloc>().add(DeleteUsers(user.id));
                SnackbarUtils.showSuccess(
                  context,
                  'Đang xóa người dùng...',
                  null,
                );
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Xóa', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}
