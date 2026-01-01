import 'package:equatable/equatable.dart';

abstract class ProductsAdminEvent extends Equatable {
  const ProductsAdminEvent();
  @override
  List<Object> get props => [];
}

class LoadProducts extends ProductsAdminEvent {}

class UpdateProducts extends ProductsAdminEvent {
  final String productId;
  final Map<String, String> name;
  final int price;
  final Map<String, String> description;
  final String imageUrl;
  final String categoryId;

  const UpdateProducts({
    required this.productId,
    required this.name,
    required this.price,
    required this.description,
    required this.imageUrl,
    required this.categoryId,
  });
  @override
  List<Object> get props => [
    productId,
    name,
    price,
    description,
    imageUrl,
    categoryId,
  ];
}

class DeleteProducts extends ProductsAdminEvent {
  final String productId;
  const DeleteProducts(this.productId);
  @override
  List<Object> get props => [productId];
}

class SearchProducts extends ProductsAdminEvent {
  final String query;
  const SearchProducts(this.query);
  @override
  List<Object> get props => [query];
}

class AddProduct extends ProductsAdminEvent {
  final Map<String, String> names;
  final String imageUrl;
  final int price;
  final Map<String, String> descriptions;
  final String categoryId;
  const AddProduct({
    required this.names,
    required this.imageUrl,
    required this.price,
    required this.descriptions,
    required this.categoryId,
  });

  @override
  List<Object> get props => [names, imageUrl, price, descriptions, categoryId];
}
