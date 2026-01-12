import 'package:equatable/equatable.dart';
import 'package:shop_core/shop_core.dart';

abstract class AdminDashboardEvent extends Equatable {
  const AdminDashboardEvent();
  @override
  List<Object> get props => [];
}

class LoadDashboardData extends AdminDashboardEvent {}

// Sự kiện nội bộ: Được gọi khi Stream orders trả về dữ liệu mới
class UpdateOrdersData extends AdminDashboardEvent {
  final List<OrderModel> orders;
  const UpdateOrdersData(this.orders);
  @override
  List<Object> get props => [orders];
}

// Sự kiện nội bộ: Được gọi khi Stream products trả về dữ liệu mới
class UpdateProductsData extends AdminDashboardEvent {
  final List<Product> products;
  const UpdateProductsData(this.products);
  @override
  List<Object> get props => [products];
}
