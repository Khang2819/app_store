import 'package:equatable/equatable.dart';
import 'package:shop_core/shop_core.dart';

class OrdersAdminState extends Equatable {
  final bool isLoading;
  final List<OrderModel> orders;
  final List<OrderModel> allOrders;
  final String? errorMessage;
  final bool isActionLoading;
  final String filterStatus;

  const OrdersAdminState({
    this.isLoading = false,
    this.orders = const [],
    this.allOrders = const [],
    this.errorMessage,
    this.isActionLoading = false,
    this.filterStatus = 'all',
  });

  OrdersAdminState copyWith({
    bool? isLoading,
    List<OrderModel>? orders,
    List<OrderModel>? allOrders,
    String? errorMessage,
    bool? isActionLoading,
    String? filterStatus,
  }) {
    return OrdersAdminState(
      isLoading: isLoading ?? this.isLoading,
      orders: orders ?? this.orders,
      allOrders: allOrders ?? this.allOrders,
      errorMessage: errorMessage,
      isActionLoading: isActionLoading ?? this.isActionLoading,
      filterStatus: filterStatus ?? this.filterStatus,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    orders,
    errorMessage,
    isActionLoading,
    allOrders,
    filterStatus,
  ];
}
