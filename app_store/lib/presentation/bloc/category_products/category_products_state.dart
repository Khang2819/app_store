import 'package:equatable/equatable.dart';

import 'package:shop_core/shop_core.dart';

class CategoryProductsState extends Equatable {
  final bool isLoading;
  final List<Product> products;
  final String? error;

  const CategoryProductsState({
    this.isLoading = false,
    this.products = const [],
    this.error,
  });
  CategoryProductsState copyWith({
    bool? isLoading,
    List<Product>? products,
    String? error,
  }) {
    return CategoryProductsState(
      isLoading: isLoading ?? this.isLoading,
      products: products ?? this.products,
      error: error,
    );
  }

  @override
  List<Object?> get props => [isLoading, products, error];
}
