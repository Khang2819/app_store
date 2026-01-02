import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_core/shop_core.dart'; // Giả sử OrderRepository khai báo ở đây
import 'orders_admin_event.dart';
import 'orders_admin_state.dart';

class OrdersAdminBloc extends Bloc<OrdersAdminEvent, OrdersAdminState> {
  final OrderRepository _orderRepository = OrderRepository();

  OrdersAdminBloc() : super(const OrdersAdminState()) {
    on<LoadOrders>(_onLoadOrders);
    on<UpdateOrderStatus>(_onUpdateOrderStatus);
  }

  Future<void> _onLoadOrders(
    LoadOrders event,
    Emitter<OrdersAdminState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    try {
      final orders = await _orderRepository.fetchAllOrdersForAdmin();
      emit(state.copyWith(isLoading: false, orders: orders));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> _onUpdateOrderStatus(
    UpdateOrderStatus event,
    Emitter<OrdersAdminState> emit,
  ) async {
    try {
      await _orderRepository.updateOrderStatus(
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
