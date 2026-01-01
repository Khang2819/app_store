import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_admin_web/presentation/widgets/admin_sidebar.dart';
import 'package:shop_core/shop_core.dart';

import '../bloc/products/products_admin_bloc.dart';
import '../bloc/products/products_admin_event.dart';
import '../bloc/products/products_admin_state.dart';
import '../widgets/add_product_dialog.dart';
import '../widgets/containerbox.dart';
import '../widgets/fiterchip.dart';
import '../widgets/header_admin.dart';
import '../widgets/product_table_row.dart';
import '../widgets/search_admin.dart';
import '../widgets/tablerow.dart';
import '../widgets/wellcome.dart';

class AdminProductsScreen extends StatelessWidget {
  const AdminProductsScreen({super.key});

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

  Widget _buildDesktopLayout(BuildContext content) {
    return Scaffold(
      body: Row(
        children: [
          AdminSidebar(isExpanded: true),
          Expanded(
            child: Column(
              children: [
                HeaderAdmin(),
                Expanded(child: ProductsContext(isMobile: false)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Scaffold();
  }
}

class ProductsContext extends StatelessWidget {
  final bool isMobile;
  const ProductsContext({super.key, this.isMobile = false});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductsAdminBloc, ProductsAdminState>(
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
              children: [
                Wellcome(
                  title: 'Quản lý sản phẩm',
                  icon: Icons.inventory_2_outlined,
                  buttonIcon: Icons.add_circle_outline,
                  buttonText: 'Thêm sản phẩm  ',
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => const AddProductDialog(),
                    );
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Containerbox(
                        title: 'Tổng số sản phẩm',
                        count: 36,
                        color: Colors.blue,
                        icon: Icons.inventory_2,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Containerbox(
                        title: 'Tổng số sản phẩm',
                        count: 36,
                        color: Colors.green,
                        icon: Icons.check_circle,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Containerbox(
                        title: 'Tổng số sản phẩm',
                        count: 36,
                        color: Colors.orange,
                        icon: Icons.check_circle,
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
                          const Expanded(
                            child: SearchAdmin(text: 'Tìm kiếm tên sản phẩm'),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: Colors.grey[50],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey[200]!),
                            ),
                            child: DropdownButton<int>(
                              value: 10,
                              underline: const SizedBox(),
                              icon: Icon(
                                Icons.arrow_drop_down,
                                color: Colors.grey[600],
                              ),
                              items:
                                  [10, 25, 50, 100].map((value) {
                                    return DropdownMenuItem(
                                      value: value,
                                      child: Text('$value / trang'),
                                    );
                                  }).toList(),
                              onChanged: (value) {},
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          Fiterchip(
                            title: 'Tất cả',
                            value: 'all',
                            currentValue: 'all',
                            icon: Icons.apps,
                          ),
                          Fiterchip(
                            title: 'Người dùng',
                            value: 'active',
                            currentValue: 'active',
                            icon: Icons.check_circle,
                          ),
                          Fiterchip(
                            title: 'Quản trị viên',
                            value: 'inactive',
                            currentValue: 'inactive',
                            icon: Icons.access_time,
                          ),
                          Fiterchip(
                            title: 'Bị cấm',
                            value: 'banned',
                            currentValue: 'banned',
                            icon: Icons.block,
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
                              flex: 3,
                              child: _buildHeaderCell(
                                'Sản phẩm',
                                Icons.shopping_bag,
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: _buildHeaderCell(
                                'Giá',
                                Icons.attach_money,
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: _buildHeaderCell(
                                'Đã bán',
                                Icons.trending_up,
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: _buildHeaderCell('Tồn kho', Icons.storage),
                            ),
                            Expanded(
                              flex: 1,
                              child: _buildHeaderCell('Đánh giá', Icons.star),
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
                      // Product List
                      _buildProductList(context, state),
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

  /// Xây dựng danh sách các hàng dữ liệu sản phẩm
  Widget _buildProductList(BuildContext context, ProductsAdminState state) {
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

    if (state.products.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: Text('Không tìm thấy sản phẩm nào.'),
        ),
      );
    }

    return Column(
      children: List.generate(state.products.length, (index) {
        final product = state.products[index];
        return TableRowItem(
          index: index,
          totalUsers:
              state.products.length, // Tái sử dụng totalUsers cho animation
          child: ProductTableRow(
            product: product,
            onEdit: () {
              // TODO: Logic hiển thị dialog/form sửa sản phẩm
            },
            onDelete: () => _confirmDelete(context, product),
          ),
        );
      }),
    );
  }

  // Hiển thị Dialog xác nhận xóa sản phẩm
  void _confirmDelete(BuildContext context, Product product) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        // Lấy tên tiếng Việt (vi) hoặc tên đầu tiên nếu không có 'vi'
        final productName =
            product.name['vi'] ?? product.name.values.first ?? 'Sản phẩm này';

        return AlertDialog(
          title: const Text('Xác nhận xóa sản phẩm'),
          content: Text(
            'Bạn có chắc chắn muốn xóa sản phẩm "$productName" không? Hành động này không thể hoàn tác.',
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
                context.read<ProductsAdminBloc>().add(
                  DeleteProducts(product.id),
                );
                SnackbarUtils.showSuccess(
                  context,
                  'Đang xóa sản phẩm...',
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
