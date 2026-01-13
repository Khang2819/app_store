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
    on<SearchOrders>(_onSearchOrders);
    on<FilterOrders>(_onFilterOrders);
    on<DeleteOrder>(_onDeleteOrder);
  }

  Future<void> _onLoadOrders(
    LoadOrders event,
    Emitter<OrdersAdminState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final orders = await orderRepository.fetchAllOrdersForAdmin();
      emit(
        state.copyWith(
          isLoading: false,
          orders: orders,
          allOrders: orders,
          errorMessage: null,
          filterStatus: 'all',
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  void _onFilterOrders(FilterOrders event, Emitter<OrdersAdminState> emit) {
    List<OrderModel> filteredList = List.from(state.allOrders);
    final status = event.status;

    if (status != 'all') {
      filteredList =
          filteredList.where((order) {
            // Chuẩn hóa chuỗi về chữ thường và xóa khoảng trắng thừa
            final s = order.status.toLowerCase().trim();

            if (status == 'pending') {
              // Bao gồm: 'đang chờ xử lý', 'đang xử lý', 'chờ xác nhận'
              return s.contains('chờ') || s.contains('xử lý');
            } else if (status == 'shipping') {
              // Bao gồm: 'đã vận chuyển', 'đang giao'
              // LƯU Ý: Phải loại trừ trường hợp 'đã giao hàng'
              return (s.contains('vận chuyển') || s.contains('đang giao'));
            } else if (status == 'delivered') {
              // Bao gồm: 'đã giao hàng', 'hoàn thành'
              return s == 'đã giao hàng' ||
                  s == 'hoàn thành' ||
                  s.contains('thành công');
            } else if (status == 'cancelled') {
              // Bao gồm: 'đã hủy', 'hủy đơn'
              return s.contains('hủy');
            }
            return true;
          }).toList();
    }

    emit(state.copyWith(orders: filteredList, filterStatus: status));
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

  Future<void> _onSearchOrders(
    SearchOrders event,
    Emitter<OrdersAdminState> emit,
  ) async {
    // Bật trạng thái loading nhẹ (nếu muốn) hoặc giữ nguyên UI cũ
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      // Gọi hàm searchOrders vừa viết ở Repository
      final results = await orderRepository.searchOrders(event.query);

      // Cập nhật danh sách orders mới vào state
      emit(
        state.copyWith(isLoading: false, orders: results, errorMessage: null),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Lỗi khi tìm kiếm đơn hàng: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onDeleteOrder(
    DeleteOrder event,
    Emitter<OrdersAdminState> emit,
  ) async {
    // Tùy chọn: Bạn có thể emit loading nếu muốn hiện vòng xoay
    // emit(state.copyWith(isLoading: true));

    try {
      // Gọi repo để xóa trên Firebase
      await orderRepository.deleteOrderAdmin(event.orderId, event.userId);

      // Sau khi xóa xong, load lại danh sách để cập nhật UI
      add(LoadOrders());
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Lỗi khi xóa đơn hàng: ${e.toString()}',
        ),
      );
    }
  }
}
