import 'package:equatable/equatable.dart';

abstract class ProductDetailEvent extends Equatable {
  const ProductDetailEvent();
  @override
  List<Object?> get props => [];
}

class LoadProductDetail extends ProductDetailEvent {
  final String productId;
  const LoadProductDetail(this.productId);
  @override
  List<Object?> get props => [productId];
}

class AddToCart extends ProductDetailEvent {
  final String productId;
  final int quantity;
  const AddToCart({required this.productId, required this.quantity});
  @override
  List<Object?> get props => [productId, quantity];
}

class AddReview extends ProductDetailEvent {
  final String productId;
  final double rating;
  final String comment;
  const AddReview({
    required this.productId,
    required this.rating,
    required this.comment,
  });
  @override
  List<Object?> get props => [productId, rating, comment];
}

class QuantityChanged extends ProductDetailEvent {
  final int quantity;
  const QuantityChanged(this.quantity);
  @override
  List<Object?> get props => [quantity];
}

class ResetAddToCartStatus extends ProductDetailEvent {}
