import 'package:equatable/equatable.dart';

import '../../../data/models/product_model.dart';

class SearchState extends Equatable {
  final bool isLoading;
  final List<Product> results;
  final String? error;
  const SearchState({
    this.isLoading = false,
    this.results = const [],
    this.error,
  });
  SearchState copyWith({
    bool? isLoading,
    List<Product>? results,
    String? error,
  }) {
    return SearchState(
      isLoading: isLoading ?? this.isLoading,
      results: results ?? this.results,
      error: error,
    );
  }

  @override
  List<Object?> get props => [isLoading, results, error];
}
