import 'package:equatable/equatable.dart';

import '../../../data/models/product_model.dart';

class HomeState extends Equatable {
  final bool isLoading;
  final List<Product> categories;
  final List<Product> products;
  final List<String> favorites;
  final String? error;

  const HomeState({
    this.isLoading = false,
    this.categories = const [],
    this.products = const [],
    this.favorites = const [],
    this.error,
  });
  HomeState copyWith({
    bool? isLoading,
    List<Product>? categories,
    List<Product>? products,
    List<String>? favorites,
    String? error,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      categories: categories ?? this.categories,
      products: products ?? this.products,
      favorites: favorites ?? this.favorites,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    categories,
    products,
    favorites,
    error,
  ];
}
