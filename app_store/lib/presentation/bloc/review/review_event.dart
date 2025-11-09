import 'package:equatable/equatable.dart';

abstract class ReviewEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadReview extends ReviewEvent {
  final String productId;
  LoadReview(this.productId);
  @override
  List<Object> get props => [productId];
}
