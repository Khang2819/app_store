import 'package:equatable/equatable.dart';

import '../../../data/models/banner_model.dart';
import '../../../data/models/category_model.dart';
import '../../../data/models/product_model.dart';

class HomeState extends Equatable {
  final bool isLoading;
  final List<Category> categories;
  final List<Product> products;
  final List<String> favorites;
  final List<BannerModel> banners;
  final String? error;

  const HomeState({
    this.isLoading = false,
    this.categories = const [],
    this.products = const [],
    this.favorites = const [],
    this.banners = const [],
    this.error,
  });
  HomeState copyWith({
    bool? isLoading,
    List<Category>? categories,
    List<Product>? products,
    List<String>? favorites,
    List<BannerModel>? banners,
    String? error,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      categories: categories ?? this.categories,
      products: products ?? this.products,
      favorites: favorites ?? this.favorites,
      banners: banners ?? this.banners,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    categories,
    products,
    favorites,
    banners,
    error,
  ];
}
