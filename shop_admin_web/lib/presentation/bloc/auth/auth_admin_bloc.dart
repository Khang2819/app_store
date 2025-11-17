import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_core/shop_core.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthAdminBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  AuthAdminBloc(this.authRepository) : super(const AuthState()) {
    on<LoginRequested>(_onLoginRequested);
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      await authRepository.signInWithEmail(
        email: event.email,
        password: event.password,
      );
      emit(state.copyWith(isLoading: false, isSuccess: true));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }
}
