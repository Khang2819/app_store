import 'package:equatable/equatable.dart';

class NavigationState extends Equatable {
  final int tabIndex;
  const NavigationState({this.tabIndex = 0});

  @override
  List<Object> get props => [tabIndex];
}
