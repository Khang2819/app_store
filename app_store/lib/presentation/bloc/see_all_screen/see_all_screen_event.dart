import 'package:equatable/equatable.dart';

abstract class SeeAllScreenEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadSeeAll extends SeeAllScreenEvent {}

class SearchSeeAll extends SeeAllScreenEvent {
  final String query;
  SearchSeeAll(this.query);
  @override
  List<Object> get props => [query];
}
