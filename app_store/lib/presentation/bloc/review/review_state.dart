import 'package:equatable/equatable.dart';

import '../../../data/models/review_model.dart';

class ReviewState extends Equatable {
  final bool isLoading;
  final String? error;
  final List<Review> reviews;
  const ReviewState({
    this.isLoading = false,
    this.error,
    this.reviews = const [],
  });
  ReviewState copyWith({
    bool? isLoading,
    String? error,
    List<Review>? reviews,
  }) {
    return ReviewState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      reviews: reviews ?? this.reviews,
    );
  }

  @override
  List<Object?> get props => [isLoading, error, reviews];
}
