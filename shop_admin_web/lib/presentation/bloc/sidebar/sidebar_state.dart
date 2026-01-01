import 'package:equatable/equatable.dart';

class SidebarState extends Equatable {
  final int tabIndex;
  const SidebarState({this.tabIndex = 0});

  @override
  List<Object> get props => [tabIndex];
}
