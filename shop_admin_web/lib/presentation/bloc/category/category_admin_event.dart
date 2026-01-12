import 'package:equatable/equatable.dart';

abstract class CategoryAdminEvent extends Equatable {
  const CategoryAdminEvent();
  @override
  List<Object> get props => [];
}

class LoadCategories extends CategoryAdminEvent {}

class AddCategory extends CategoryAdminEvent {
  final Map<String, String> names;
  final String imageUrl;
  const AddCategory({required this.names, required this.imageUrl});
  @override
  List<Object> get props => [names, imageUrl];
}

class DeleteCategory extends CategoryAdminEvent {
  final String categoryId;
  const DeleteCategory(this.categoryId);
  @override
  List<Object> get props => [categoryId];
}

class UpdateCategory extends CategoryAdminEvent {
  final String categoryId;
  final Map<String, String> names;
  final String imageUrl;
  const UpdateCategory(this.categoryId, this.names, this.imageUrl);
  @override
  List<Object> get props => [categoryId, names, imageUrl];
}
