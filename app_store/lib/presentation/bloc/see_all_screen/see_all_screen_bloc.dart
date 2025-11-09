// lib/presentation/bloc/see_all_screen/see_all_screen_bloc.dart
import 'package:bloc_app/presentation/bloc/see_all_screen/see_all_screen_event.dart';
import 'package:bloc_app/presentation/bloc/see_all_screen/see_all_screen_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/product_model.dart'; // THÊM IMPORT
import '../../../data/repositories/product_repository.dart';

class SeeAllScreenBloc extends Bloc<SeeAllScreenEvent, SeeAllScreenState> {
  final ProductRepository _repository;
  SeeAllScreenBloc(this._repository) : super(const SeeAllScreenState()) {
    on<LoadSeeAll>(_onLoadSeeAll);
    on<SearchSeeAll>(_onSearchSeeAll); // THÊM MỚI
  }

  List<Product> _filterProducts(List<Product> products, String query) {
    if (query.isEmpty) return products;
    final lowerCaseQuery = query.toLowerCase();
    return products.where((product) {
      // Lọc theo tên sản phẩm đa ngôn ngữ
      final names = product.name.values.map((v) => v.toString()).toList();
      return names.any((name) => name.toLowerCase().contains(lowerCaseQuery));
    }).toList();
  }

  Future<void> _onLoadSeeAll(
    LoadSeeAll event,
    Emitter<SeeAllScreenState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));
    final user = FirebaseAuth.instance.currentUser;
    try {
      final allProducts = await _repository.fetchProducts();
      final latestProducts = await _repository.fetchLatestProducts();
      final bestSellingProducts = await _repository.fetchBestsellingProducts();
      List<String> favorites = [];
      if (user != null) {
        favorites = await _repository.fetchFavorites(user.uid);
      }

      // Lọc dữ liệu ban đầu (query rỗng) để set cho filtered lists
      final filteredAll = _filterProducts(allProducts, state.searchQuery);
      final filteredLatest = _filterProducts(latestProducts, state.searchQuery);
      final filteredBestSelling = _filterProducts(
        bestSellingProducts,
        state.searchQuery,
      );

      emit(
        state.copyWith(
          isLoading: false,
          // Lưu danh sách gốc
          allProducts: allProducts,
          latestProducts: latestProducts,
          bestSellingProducts: bestSellingProducts,
          favorites: favorites,
          // Cập nhật danh sách đã lọc
          filteredAllProducts: filteredAll,
          filteredLatestProducts: filteredLatest,
          filteredBestSellingProducts: filteredBestSelling,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  // THÊM MỚI: Logic tìm kiếm
  void _onSearchSeeAll(SearchSeeAll event, Emitter<SeeAllScreenState> emit) {
    final query = event.query;

    // Lọc lại 3 danh sách gốc
    final filteredAll = _filterProducts(state.allProducts, query);
    final filteredLatest = _filterProducts(state.latestProducts, query);
    final filteredBestSelling = _filterProducts(
      state.bestSellingProducts,
      query,
    );

    emit(
      state.copyWith(
        searchQuery: query,
        filteredAllProducts: filteredAll,
        filteredLatestProducts: filteredLatest,
        filteredBestSellingProducts: filteredBestSelling,
      ),
    );
  }
}
