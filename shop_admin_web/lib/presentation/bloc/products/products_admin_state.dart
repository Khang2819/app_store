import 'package:equatable/equatable.dart';
import 'package:shop_core/shop_core.dart';

class ProductsAdminState extends Equatable {
  final bool isLoading;
  final String? errorMessage;
  final List<Product> products;
  final bool isActionLoading;

  const ProductsAdminState({
    this.isLoading = true,
    this.errorMessage,
    this.products = const [],
    this.isActionLoading = false,
  });
  ProductsAdminState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<Product>? products,
    bool? isActionLoading,
  }) {
    return ProductsAdminState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      products: products ?? this.products,
      isActionLoading: isActionLoading ?? this.isActionLoading,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    errorMessage,
    products,
    isActionLoading,
  ];
}
