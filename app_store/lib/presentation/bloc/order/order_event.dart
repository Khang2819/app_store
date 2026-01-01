import 'package:equatable/equatable.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();
  @override
  List<Object> get props => [];
}

class LoadOrderHistory extends OrderEvent {}

class DeleteOrder extends OrderEvent {
  final String orderId;
  const DeleteOrder(this.orderId);

  @override
  List<Object> get props => [orderId];
}
