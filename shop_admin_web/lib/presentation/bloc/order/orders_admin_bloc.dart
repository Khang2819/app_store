import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_core/shop_core.dart'; // Giả sử OrderRepository khai báo ở đây
import 'orders_admin_event.dart';
import 'orders_admin_state.dart';

class OrdersAdminBloc extends Bloc<OrdersAdminEvent, OrdersAdminState> {
  final OrderRepository orderRepository;

  OrdersAdminBloc({required this.orderRepository})
    : super(const OrdersAdminState()) {
    on<LoadOrders>(_onLoadOrders);
    on<UpdateOrderStatus>(_onUpdateOrderStatus);
  }

  Future<void> _onLoadOrders(
    LoadOrders event,
    Emitter<OrdersAdminState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final orders = await orderRepository.fetchAllOrdersForAdmin();
      emit(
        state.copyWith(isLoading: false, orders: orders, errorMessage: null),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> _onUpdateOrderStatus(
    UpdateOrderStatus event,
    Emitter<OrdersAdminState> emit,
  ) async {
    try {
      await orderRepository.updateOrderStatus(
        event.userId,
        event.orderId,
        event.newStatus,
      );
      add(LoadOrders()); // Tải lại danh sách sau khi cập nhật thành công
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }
}
