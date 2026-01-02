import 'package:equatable/equatable.dart';
import 'package:shop_core/shop_core.dart';

class OrdersAdminState extends Equatable {
  final bool isLoading;
  final List<OrderModel> orders;
  final String? errorMessage;
  final bool isActionLoading;

  const OrdersAdminState({
    this.isLoading = false,
    this.orders = const [],
    this.errorMessage,
    this.isActionLoading = false,
  });

  OrdersAdminState copyWith({
    bool? isLoading,
    List<OrderModel>? orders,
    String? errorMessage,
    bool? isActionLoading,
  }) {
    return OrdersAdminState(
      isLoading: isLoading ?? this.isLoading,
      orders: orders ?? this.orders,
      errorMessage: errorMessage,
      isActionLoading: isActionLoading ?? this.isActionLoading,
    );
  }

  @override
  List<Object?> get props => [isLoading, orders, errorMessage, isActionLoading];
}
