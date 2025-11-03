import 'package:equatable/equatable.dart';

abstract class CategoryProductsEvent extends Equatable {
  const CategoryProductsEvent();
  @override
  List<Object> get props => [];
}

class LoadCategoryProduct extends CategoryProductsEvent {
  final String categoryId;
  const LoadCategoryProduct(this.categoryId);
  @override
  List<Object> get props => [categoryId];
}
