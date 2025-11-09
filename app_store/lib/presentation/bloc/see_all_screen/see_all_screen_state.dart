import 'package:bloc_app/data/models/product_model.dart';
import 'package:equatable/equatable.dart';

class SeeAllScreenState extends Equatable {
  final List<Product> allProducts;
  final List<Product> latestProducts;
  final List<Product> bestSellingProducts;
  final List<Product> filteredAllProducts;
  final List<Product> filteredLatestProducts;
  final List<Product> filteredBestSellingProducts;
  final List<String> favorites;
  final bool isLoading;
  final String? error;
  final String searchQuery;

  const SeeAllScreenState({
    this.allProducts = const [],
    this.latestProducts = const [],
    this.bestSellingProducts = const [],
    this.filteredAllProducts = const [], // KHỞI TẠO
    this.filteredLatestProducts = const [], // KHỞI TẠO
    this.filteredBestSellingProducts = const [], // KHỞI TẠO
    this.favorites = const [],
    this.isLoading = false,
    this.error,
    this.searchQuery = '',
  });
  SeeAllScreenState copyWith({
    List<Product>? allProducts,
    List<Product>? latestProducts,
    List<Product>? bestSellingProducts,
    List<Product>? filteredAllProducts, // THÊM
    List<Product>? filteredLatestProducts, // THÊM
    List<Product>? filteredBestSellingProducts,
    List<String>? favorites,
    bool? isLoading,
    String? error,
    String? searchQuery,
  }) {
    return SeeAllScreenState(
      allProducts: allProducts ?? this.allProducts,
      latestProducts: latestProducts ?? this.latestProducts,
      bestSellingProducts: bestSellingProducts ?? this.bestSellingProducts,
      filteredAllProducts:
          filteredAllProducts ?? this.filteredAllProducts, // SỬ DỤNG
      filteredLatestProducts:
          filteredLatestProducts ?? this.filteredLatestProducts, // SỬ DỤNG
      filteredBestSellingProducts:
          filteredBestSellingProducts ??
          this.filteredBestSellingProducts, // SỬ DỤNG
      favorites: favorites ?? this.favorites,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [
    allProducts,
    latestProducts,
    bestSellingProducts,
    filteredAllProducts, // THÊM
    filteredLatestProducts, // THÊM
    filteredBestSellingProducts, // THÊM
    isLoading,
    error,
    searchQuery,
  ];
}
