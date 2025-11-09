import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:shop_core/shop_core.dart';
import 'search_event.dart';
import 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final ProductRepository _repository;
  SearchBloc(this._repository) : super(SearchState()) {
    on<SearchTextChanged>(_onSearchTextChanged);
  }
  Future<void> _onSearchTextChanged(
    SearchTextChanged event,
    Emitter<SearchState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    try {
      final products = await _repository.searchProducts(event.search);
      emit(state.copyWith(isLoading: false, results: products));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }
}
