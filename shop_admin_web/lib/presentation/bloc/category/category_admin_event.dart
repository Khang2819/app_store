import 'package:equatable/equatable.dart';

abstract class CategoryAdminEvent extends Equatable {
  const CategoryAdminEvent();
  @override
  List<Object> get props => [];
}

class LoadCategories extends CategoryAdminEvent {}

class AddCategory extends CategoryAdminEvent {
  final Map<String, String> names;
  const AddCategory({required this.names});
  @override
  List<Object> get props => [names];
}

class DeleteCategory extends CategoryAdminEvent {
  final String categoryId;
  const DeleteCategory(this.categoryId);
  @override
  List<Object> get props => [categoryId];
}
