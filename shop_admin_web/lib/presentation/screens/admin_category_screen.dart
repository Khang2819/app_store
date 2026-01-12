import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_core/models/category_model.dart';

import '../bloc/category/category_admin_bloc.dart';
import '../bloc/category/category_admin_event.dart';
import '../bloc/category/category_admin_state.dart';
import '../widgets/add_category_dialog.dart';
import '../widgets/admin_sidebar.dart';
import '../widgets/category_table_row.dart';
import '../widgets/containerbox.dart';
import '../widgets/edit_category_dialog.dart';
import '../widgets/header_admin.dart';
import '../widgets/tablerow.dart';
import '../widgets/wellcome.dart';

class AdminCategoryScreen extends StatelessWidget {
  const AdminCategoryScreen({super.key});

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
                Expanded(child: CategoryContext(isMobile: false)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return const Scaffold();
  }
}

class CategoryContext extends StatelessWidget {
  final bool isMobile;
  const CategoryContext({super.key, this.isMobile = false});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryAdminBloc, CategoryAdminState>(
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
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wellcome(
                  title: 'Quản lý Doanh mục',
                  icon: Icons.category,
                  buttonIcon: Icons.add_circle_outline,
                  buttonText: 'Thêm Doanh mục',
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => const AddCategoryDialog(),
                    );
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Containerbox(
                        title: 'Tổng doang mục',
                        count: state.categories.length,
                        color: Colors.blue,
                        icon: Icons.photo_library,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Containerbox(
                        title: 'Đang hoạt động',
                        count: state.categories.length,
                        color: Colors.green,
                        icon: Icons.check_circle,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        // ignore: deprecated_member_use
                        color: const Color(0xFF667eea).withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Table Header
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
                                'Tên doanh mục',
                                Icons.photo_library,
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: _buildHeaderCell(
                                'Thông tin',
                                Icons.receipt_long,
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: _buildHeaderCell('Trạng thái', Icons.info),
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
                      _buildCategoryList(context, state),
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

  Widget _buildCategoryList(BuildContext context, CategoryAdminState state) {
    if (state.isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (state.categories.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: Text('Không có danh mục nào.'),
        ),
      );
    }

    return Column(
      children: List.generate(state.categories.length, (index) {
        final category = state.categories[index];
        return TableRowItem(
          index: index,
          totalUsers: state.categories.length,
          child: CategoryTableRow(
            category: category,
            onEdit: () {
              _showEditDialog(context, category);
            },
            onDelete: () {
              _confirmDelete(context, category);
            },
          ),
        );
      }),
    );
  }

  void _showEditDialog(BuildContext context, Category category) {
    showDialog(
      context: context,
      builder: (_) => EditCategoryDialog(category: category),
    );
  }

  void _confirmDelete(BuildContext context, Category category) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Xác nhận xóa'),
            content: Text(
              'Bạn có chắc muốn xóa danh mục "${category.name['vi']}"?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Hủy'),
              ),
              ElevatedButton(
                onPressed: () {
                  context.read<CategoryAdminBloc>().add(
                    DeleteCategory(category.id),
                  );
                  Navigator.pop(context);
                },
                child: const Text('Xóa'),
              ),
            ],
          ),
    );
  }
}
