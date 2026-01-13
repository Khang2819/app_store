import 'package:equatable/equatable.dart';
import 'package:shop_core/shop_core.dart';

class ProductsAdminState extends Equatable {
  final bool isLoading;
  final String? errorMessage;
  final List<Product> products;
  final List<Product> allProducts;
  final bool isActionLoading;
  final String filterStatus;

  const ProductsAdminState({
    this.isLoading = true,
    this.errorMessage,
    this.products = const [],
    this.allProducts = const [],
    this.isActionLoading = false,
    this.filterStatus = 'all',
  });
  ProductsAdminState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<Product>? products,
    List<Product>? allProducts,
    bool? isActionLoading,
    String? filterStatus,
  }) {
    return ProductsAdminState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      products: products ?? this.products,
      allProducts: allProducts ?? this.allProducts,
      isActionLoading: isActionLoading ?? this.isActionLoading,
      filterStatus: filterStatus ?? this.filterStatus,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    errorMessage,
    products,
    allProducts,
    isActionLoading,
    filterStatus,
  ];
}
