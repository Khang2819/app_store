import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_core/shop_core.dart';
import 'admin_dashboard_event.dart';
import 'admin_dashboard_state.dart';

class AdminDashboardBloc
    extends Bloc<AdminDashboardEvent, AdminDashboardState> {
  final ProductRepository productRepository;
  final UserRepository userRepository;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  AdminDashboardBloc({
    required this.productRepository,
    required this.userRepository,
  }) : super(const AdminDashboardState()) {
    on<LoadDashboardData>(_onLoadDashboardData);
  }

  Future<void> _onLoadDashboardData(
    LoadDashboardData event,
    Emitter<AdminDashboardState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      final metrics = await userRepository.fetchDashboardMetrics();
      // tổng số sản phẩm
      final products = await _firestore.collection('products').count().get();
      final newTotalProducts = products.count.toString();
      emit(
        state.copyWith(
          isLoading: false,
          totalUsers: metrics['totalUsers'] ?? '...',
          totalOrders: metrics['totalUsers'] ?? '...',
          totalRevenue: metrics['totalRevenue'] ?? '...',
          totalProducts: newTotalProducts,
          errorMessage: null,
        ),
      );
    } catch (e) {
      // Xử lý lỗi
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Lỗi tải dữ liệu Dashboard: ${e.toString()}',
        ),
      );
    }
  }
}
