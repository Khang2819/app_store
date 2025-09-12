import 'package:bloc_app/presentation/bloc/auth/auth_even.dart';
import 'package:bloc_app/presentation/bloc/auth/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/validators.dart';
import '../../../data/repositories/auth_login.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc(this.authRepository) : super(const AuthState()) {
    on<LoginSubmitted>(_onLoginSubmitted);
    on<Register>(_onRegister);
    on<ClearAuthStatus>((event, emit) {
      emit(state.copyWith(isSuccess: false, generalError: null));
    });

    on<EmailChanged>((event, emit) {
      emit(
        state.copyWith(
          email: event.email,
          emailError: null,
          generalError: null,
          isSuccess: false,
        ),
      );
    });
    on<PasswordChanged>((event, emit) {
      emit(
        state.copyWith(
          password: event.password,
          passwordError: null,
          generalError: null,
          isSuccess: false,
        ),
      );
    });
    on<NameChanged>((event, emit) {
      emit(
        state.copyWith(
          name: event.name,
          nameError: null,
          generalError: null,
          isSuccess: false,
        ),
      );
    });
    on<ConfirmPasswordChanged>((event, emit) {
      emit(
        state.copyWith(
          confirmPassword: event.confirmPassword,
          confirmPasswordError: null,
          generalError: null,
          isSuccess: false,
        ),
      );
    });
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    final emailError = Validators.validateEmail(event.email);
    final passwordError = Validators.validatePassword(event.password);

    if (emailError != null || passwordError != null) {
      emit(
        state.copyWith(
          emailError: emailError,
          passwordError: passwordError,
          isSuccess: false,
        ),
      );
      return;
    }

    emit(state.copyWith(isLoading: true, generalError: null));
    try {
      await authRepository.signInWithEmail(event.email, event.password);
      emit(state.copyWith(isLoading: false, isSuccess: true));
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          generalError: e.toString(),
          isSuccess: false,
        ),
      );
    }
  }

  Future<void> _onRegister(Register event, Emitter<AuthState> emit) async {
    final nameError = Validators.validateName(event.name);
    final emailError = Validators.validateEmail(event.email);
    final passwordError = Validators.validatePassword(event.password);
    final confirmPasswordError = Validators.validateConfirmPassword(
      event.password,
      event.confirmPassword,
    );

    if (nameError != null ||
        emailError != null ||
        passwordError != null ||
        confirmPasswordError != null) {
      emit(
        state.copyWith(
          nameError: nameError,
          emailError: emailError,
          passwordError: passwordError,
          confirmPasswordError: confirmPasswordError,
          generalError: null,
          isSuccess: false,
        ),
      );
      return;
    }
    emit(state.copyWith(isLoading: true, generalError: null));
    try {
      await authRepository.signUpWithEmail(
        event.name,
        event.email,
        event.password,
      );
      emit(state.copyWith(isLoading: false, isSuccess: true));
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          generalError: e.toString(),
          isSuccess: false, // show message chi tiết hơn
        ),
      );
    }
  }
}
