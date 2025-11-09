import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class LoadHomeData extends HomeEvent {}

class ToggleFavorite extends HomeEvent {
  final String productId;
  const ToggleFavorite(this.productId);

  @override
  List<Object?> get props => [productId];
}
