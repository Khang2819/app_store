// lib/presentation/bloc/content/content_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';

import 'sidebar_event.dart';
import 'sidebar_state.dart';

class SidebarBloc extends Bloc<SidebarEvent, SidebarState> {
  SidebarBloc() : super(SidebarState(tabIndex: 0)) {
    on<SelectPage>((event, emit) {
      emit(SidebarState(tabIndex: event.index));
    });
  }
}
