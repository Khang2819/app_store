import 'package:equatable/equatable.dart';
import 'package:shop_core/shop_core.dart';

class FavoritesState extends Equatable {
  final List<Product> favoriteProducts;
  final List<Product> allFavoriteProducts;
  final bool isLoading;
  final String? error;
  final String searchQuery;

  const FavoritesState({
    this.favoriteProducts = const [],
    this.allFavoriteProducts = const [],
    this.isLoading = false,
    this.error,
    this.searchQuery = '',
  });

  FavoritesState copyWith({
    List<Product>? favoriteProducts,
    List<Product>? allFavoriteProducts,
    bool? isLoading,
    String? error,
    String? searchQuery,
  }) {
    return FavoritesState(
      favoriteProducts: favoriteProducts ?? this.favoriteProducts,
      allFavoriteProducts: allFavoriteProducts ?? this.allFavoriteProducts,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [
    favoriteProducts,
    allFavoriteProducts,
    isLoading,
    error,
    searchQuery,
  ];
}
