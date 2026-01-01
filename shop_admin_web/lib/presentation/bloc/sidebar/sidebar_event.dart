import 'package:equatable/equatable.dart';

abstract class SidebarEvent extends Equatable {
  const SidebarEvent();
  @override
  List<Object> get props => [];
}

class SelectPage extends SidebarEvent {
  final int index;
  const SelectPage(this.index);
  @override
  List<Object> get props => [index];
}
