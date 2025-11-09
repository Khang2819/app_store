import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/repositories/product_repository.dart';
import 'review_event.dart';
import 'review_state.dart';

class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  final ProductRepository _repository;
  ReviewBloc(this._repository) : super(ReviewState()) {
    on<LoadReview>(_onLoadReview);
  }

  Future<void> _onLoadReview(
    LoadReview event,
    Emitter<ReviewState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final allReview = await _repository.fetchReviews(event.productId);
      emit(state.copyWith(isLoading: false, reviews: allReview));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }
}
