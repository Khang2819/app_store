import 'package:equatable/equatable.dart';
import 'package:shop_core/shop_core.dart'; // Đảm bảo đã có Category model trong core

class CategoryAdminState extends Equatable {
  final bool isLoading;
  final List<Category> categories;
  final String? errorMessage;

  const CategoryAdminState({
    this.isLoading = false,
    this.categories = const [],
    this.errorMessage,
  });

  CategoryAdminState copyWith({
    bool? isLoading,
    List<Category>? categories,
    String? errorMessage,
  }) {
    return CategoryAdminState(
      isLoading: isLoading ?? this.isLoading,
      categories: categories ?? this.categories,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [isLoading, categories, errorMessage];
}
