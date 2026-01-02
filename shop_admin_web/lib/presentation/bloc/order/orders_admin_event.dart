import 'package:equatable/equatable.dart';

abstract class OrdersAdminEvent extends Equatable {
  const OrdersAdminEvent();
  @override
  List<Object?> get props => [];
}

// Sự kiện tải danh sách đơn hàng
class LoadOrders extends OrdersAdminEvent {}

// Sự kiện cập nhật trạng thái đơn hàng (ví dụ: Chờ xử lý -> Đang giao)
class UpdateOrderStatus extends OrdersAdminEvent {
  final String userId;
  final String orderId;
  final String newStatus;

  const UpdateOrderStatus({
    required this.userId,
    required this.orderId,
    required this.newStatus,
  });

  @override
  List<Object?> get props => [userId, orderId, newStatus];
}

// Sự kiện tìm kiếm đơn hàng
class SearchOrders extends OrdersAdminEvent {
  final String query;
  const SearchOrders(this.query);

  @override
  List<Object?> get props => [query];
}
