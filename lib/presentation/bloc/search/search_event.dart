import 'package:equatable/equatable.dart';

abstract class SearchEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SearchTextChanged extends SearchEvent {
  final String search;
  SearchTextChanged(this.search);
  @override
  List<Object> get props => [search];
}
