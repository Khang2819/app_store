import 'package:shop_core/shop_core.dart';
import 'package:equatable/equatable.dart';

abstract class CartState extends Equatable {
  const CartState();
  @override
  List<Object> get props => [];
}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final List<CartItem> items;
  final int totalPrice;

  const CartLoaded({this.items = const [], this.totalPrice = 0});

  @override
  List<Object> get props => [items, totalPrice];
}

class CartSuccess extends CartState {}

class CartEmpty extends CartState {}

class CartError extends CartState {
  final String message;
  const CartError(this.message);
  @override
  List<Object> get props => [message];
}
