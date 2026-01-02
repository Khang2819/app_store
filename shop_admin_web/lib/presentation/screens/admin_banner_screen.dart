import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_core/shop_core.dart'; // Import BannerModel và SnackbarUtils

import '../bloc/banner/banner_admin_bloc.dart';
import '../bloc/banner/banner_admin_event.dart';
import '../bloc/banner/banner_admin_state.dart';
import '../widgets/add_banner_dialog.dart';
import '../widgets/admin_sidebar.dart';
import '../widgets/banner_table_row.dart';
import '../widgets/containerbox.dart';
import '../widgets/header_admin.dart';
import '../widgets/tablerow.dart';
import '../widgets/wellcome.dart';

class AdminBannerScreen extends StatelessWidget {
  const AdminBannerScreen({super.key});

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
                Expanded(child: BannedContext(isMobile: false)),
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

class BannedContext extends StatelessWidget {
  final bool isMobile;
  const BannedContext({super.key, this.isMobile = false});

  @override
  Widget build(BuildContext context) {
    // Sử dụng BlocConsumer để lắng nghe lỗi
    return BlocConsumer<BannerAdminBloc, BannerAdminState>(
      listener: (context, state) {
        if (state.errorMessage != null) {
          // Hiển thị lỗi khi có sự cố
          SnackbarUtils.showError(context, state.errorMessage!, null);
        }
      },
      builder: (context, state) {
        // TÍNH TOÁN THỐNG KÊ (Giả định isActive dựa trên trường order > 0)
        final totalBanners = state.banner.length; // Sửa banners thành banner
        final activeBanners = state.banner.where((b) => b.order > 0).length;
        final pausedBanners = totalBanners - activeBanners;

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
                  title: 'Quản lý Banner Quảng cáo',
                  icon: Icons.sell,
                  buttonIcon: Icons.add_circle_outline,
                  buttonText: 'Thêm Banner Quảng cáo',
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => const AddBannerDialog(),
                    );
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Containerbox(
                        title: 'Tổng Banner',
                        count: totalBanners,
                        color: Colors.blue,
                        icon: Icons.photo_library,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Containerbox(
                        title: 'Đang hoạt động',
                        count: activeBanners,
                        color: Colors.green,
                        icon: Icons.check_circle,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Containerbox(
                        title: 'Tạm dừng',
                        count: pausedBanners,
                        color: Colors.orange,
                        icon: Icons.pause_circle,
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
                                'Hình ảnh',
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
                      // Banner List
                      _buildBannerList(context, state),
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

  /// Xây dựng danh sách các hàng dữ liệu Banner
  Widget _buildBannerList(BuildContext context, BannerAdminState state) {
    if (state.isLoading || state.isActionLoading) {
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

    if (state.banner.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: Text('Không tìm thấy banner nào.'),
        ),
      );
    }

    return Column(
      children: List.generate(state.banner.length, (index) {
        final banner = state.banner[index];
        final isActive = banner.order > 0; // Giả định logic trạng thái
        return TableRowItem(
          index: index,
          totalUsers: state.banner.length, // Tái sử dụng cho animation
          child: BannerTableRow(
            banner: banner,
            isActive: isActive,
            onEdit: () {
              // TODO: Logic hiển thị dialog sửa banner
            },
            onDelete: () => _confirmDelete(context, banner),
            onPause: () {
              // TODO: Logic cập nhật trạng thái (isActive)
            },
          ),
        );
      }),
    );
  }

  // Hiển thị Dialog xác nhận xóa Banner
  void _confirmDelete(BuildContext context, BannerModel banner) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        final bannerInfo =
            'Banner Order: ${banner.order}, Target: ${banner.targetType}';

        return AlertDialog(
          title: const Text('Xác nhận xóa Banner'),
          content: Text(
            'Bạn có chắc chắn muốn xóa banner "$bannerInfo" không? Hành động này không thể hoàn tác.',
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
                context.read<BannerAdminBloc>().add(
                  DeleteBanner(bannerId: banner.id),
                );
                SnackbarUtils.showSuccess(context, 'Đang xóa banner...', null);
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
