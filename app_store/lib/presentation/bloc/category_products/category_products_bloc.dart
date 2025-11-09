import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:shop_core/shop_core.dart';
import 'category_products_event.dart';
import 'category_products_state.dart';

class CategoryProductsBloc
    extends Bloc<CategoryProductsEvent, CategoryProductsState> {
  final ProductRepository _repository;
  CategoryProductsBloc(this._repository)
    : super(const CategoryProductsState()) {
    on<LoadCategoryProduct>(_onLoadingCategoryProduct);
  }

  Future<void> _onLoadingCategoryProduct(
    LoadCategoryProduct event,
    Emitter<CategoryProductsState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final products = await _repository.fetchProductsByCategory(
        event.categoryId,
      );
      emit(state.copyWith(isLoading: false, products: products));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }
}
