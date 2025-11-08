import 'package:equatable/equatable.dart';
import '../../../data/models/product_model.dart';
import '../../../data/models/review_model.dart';

class ProductDetailState extends Equatable {
  final bool isLoading;
  final Product? product;
  final List<Review> reviews;
  final int quantity;
  final String? error;
  final bool canReview;
  final bool addToCartSuccess;
  final List<Product> relatedProducts;

  const ProductDetailState({
    this.isLoading = false,
    this.product,
    this.reviews = const [],
    this.quantity = 1,
    this.error,
    this.canReview = false,
    this.addToCartSuccess = false,
    this.relatedProducts = const [],
  });

  ProductDetailState copyWith({
    bool? isLoading,
    Product? product,
    List<Review>? reviews,
    int? quantity,
    String? error,
    bool? canReview,
    bool? addToCartSuccess,
    bool? clearError,
    List<Product>? relatedProducts,
  }) {
    return ProductDetailState(
      isLoading: isLoading ?? this.isLoading,
      product: product ?? this.product,
      reviews: reviews ?? this.reviews,
      quantity: quantity ?? this.quantity,
      error: clearError == true ? null : error ?? this.error,
      canReview: canReview ?? this.canReview,
      addToCartSuccess: addToCartSuccess ?? this.addToCartSuccess,
      relatedProducts: relatedProducts ?? this.relatedProducts,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    product,
    reviews,
    quantity,
    error,
    canReview,
    addToCartSuccess,
    relatedProducts,
  ];
}
