import 'package:equatable/equatable.dart';

abstract class FavoritesEvent extends Equatable {
  const FavoritesEvent();
  @override
  List<Object?> get props => [];
}

// Event để tải chi tiết sản phẩm từ danh sách ID
class LoadFavoriteProducts extends FavoritesEvent {
  final List<String> productIds;

  const LoadFavoriteProducts(this.productIds);
  @override
  List<Object?> get props => [productIds];
}

class SearchFavorites extends FavoritesEvent {
  final String query;
  const SearchFavorites(this.query);
  @override
  List<Object?> get props => [query];
}
