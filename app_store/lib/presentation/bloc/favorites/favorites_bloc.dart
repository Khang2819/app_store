import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_core/shop_core.dart';
import 'favorites_event.dart';
import 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final ProductRepository _productRepository;

  FavoritesBloc(this._productRepository) : super(const FavoritesState()) {
    on<LoadFavoriteProducts>(_onLoadFavoriteProducts);
    on<SearchFavorites>(_onSearchFavorites);
  }

  Future<void> _onLoadFavoriteProducts(
    LoadFavoriteProducts event,
    Emitter<FavoritesState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      // Dùng repository để lấy chi tiết sản phẩm
      final products = await _productRepository.fetchProductsByIds(
        event.productIds,
      );

      // SỬA LỖI TẠI ĐÂY: Áp dụng bộ lọc tìm kiếm hiện tại (nếu có) vào danh sách mới tải về
      final filteredProducts = _filterProducts(products, state.searchQuery);

      emit(
        state.copyWith(
          isLoading: false,
          allFavoriteProducts: products, // <<< SỬA: LƯU DANH SÁCH GỐC VÀO ĐÂY
          favoriteProducts:
              filteredProducts, // Hiển thị danh sách đã lọc (nếu có truy vấn)
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onSearchFavorites(
    SearchFavorites event,
    Emitter<FavoritesState> emit,
  ) async {
    final query = event.query.toLowerCase();
    // Lấy danh sách gốc để tìm kiếm
    final allProducts = state.allFavoriteProducts;

    final filteredProducts = _filterProducts(allProducts, query);

    // Cập nhật trạng thái hiển thị và lưu truy vấn
    emit(
      state.copyWith(favoriteProducts: filteredProducts, searchQuery: query),
    );
  }

  List<Product> _filterProducts(List<Product> products, String query) {
    if (query.isEmpty) return products;
    final lowerCaseQuery = query.toLowerCase();
    return products.where((product) {
      // Lấy tất cả tên sản phẩm có sẵn (trong các ngôn ngữ) để tìm kiếm
      final names = product.name.values.map((v) => v.toString()).toList();
      return names.any((name) => name.toLowerCase().contains(lowerCaseQuery));
    }).toList();
  }
}
