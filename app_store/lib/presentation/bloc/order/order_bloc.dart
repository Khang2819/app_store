import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_core/shop_core.dart';
import 'order_event.dart';
import 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final OrderRepository _orderRepository;

  OrderBloc(this._orderRepository) : super(OrderInitial()) {
    on<LoadOrderHistory>(_onLoadOrderHistory);
    on<DeleteOrder>(_onDeleteOrder);
  }

  Future<void> _onLoadOrderHistory(
    LoadOrderHistory event,
    Emitter<OrderState> emit,
  ) async {
    emit(OrderLoading());
    try {
      final orders = await _orderRepository.fetchOrderHistory();
      if (orders.isEmpty) {
        emit(const OrderLoaded([]));
      } else {
        emit(OrderLoaded(orders));
      }
    } catch (e) {
      emit(OrderError(e.toString()));
    }
  }

  Future<void> _onDeleteOrder(
    DeleteOrder event,
    Emitter<OrderState> emit,
  ) async {
    try {
      await _orderRepository.deleteOrder(event.orderId);
      // Sau khi xóa thành công, tải lại danh sách
      add(LoadOrderHistory());
    } catch (e) {
      emit(OrderError(e.toString()));
    }
  }
}
