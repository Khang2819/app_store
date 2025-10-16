import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/product_repository.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final ProductRepository _repository;

  HomeBloc(this._repository) : super(HomeState()) {
    on<LoadHomeData>(_onLoadHomeData);
    on<ToggleFavorite>(_onToggleFavorite);
  }

  Future<void> _onLoadHomeData(
    LoadHomeData event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    try {
      final products = await _repository.fetchProducts();
      final categories = await _repository.fetchCategories();
      emit(
        state.copyWith(
          isLoading: false,
          products: products,
          categories: categories,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  void _onToggleFavorite(ToggleFavorite event, Emitter<HomeState> emit) {
    final currentFavs = List<String>.from(state.favorites);
    if (currentFavs.contains(event.productId)) {
      currentFavs.remove(event.productId);
    } else {
      currentFavs.add(event.productId);
    }
    emit(state.copyWith(favorites: currentFavs));
  }
}
