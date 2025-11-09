import 'package:bloc_app/presentation/bloc/auth/auth_even.dart';
import 'package:bloc_app/presentation/bloc/auth/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/utils.dart';
import '../../../core/validators.dart';
import '../../../data/repositories/auth_login.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc(this.authRepository) : super(const AuthState()) {
    on<LoginWithEmailEvent>(_onLoginSubmitted);
    on<RegisterWithEmailEvent>(_onRegister);
    on<LoginWithGoogle>(_onLoginWithGoogle);
    on<ForgotPasswordEvent>(_onForgot);
    on<Logout>(_onLogout);
    on<ClearAuthStatus>((event, emit) {
      emit(state.copyWith(isSuccess: false, generalError: null));
    });

    on<EmailChanged>((event, emit) {
      emit(
        state.copyWith(
          email: event.email,
          emailError: const ValueWrapper(null),
          isSuccess: false,
        ),
      );
    });
    on<PasswordChanged>((event, emit) {
      emit(
        state.copyWith(
          password: event.password,
          passwordError: const ValueWrapper(null),
          isSuccess: false,
        ),
      );
    });
    on<NameChanged>((event, emit) {
      emit(
        state.copyWith(
          name: event.name,
          nameError: const ValueWrapper(null),
          isSuccess: false,
        ),
      );
    });
    on<ConfirmPasswordChanged>((event, emit) {
      emit(
        state.copyWith(
          confirmPassword: event.confirmPassword,
          confirmPasswordError: const ValueWrapper(null),
          isSuccess: false,
        ),
      );
    });
  }

  Future<void> _onLoginSubmitted(
    LoginWithEmailEvent event,
    Emitter<AuthState> emit,
  ) async {
    final emailError = Validators.validateEmail(event.email);
    final passwordError = Validators.validatePassword(event.password);

    if (emailError != null || passwordError != null) {
      emit(
        state.copyWith(
          emailError: emailError != null ? ValueWrapper(emailError) : null,
          passwordError:
              passwordError != null ? ValueWrapper(passwordError) : null,
          isSuccess: false,
        ),
      );
      return;
    }

    emit(
      state.copyWith(isLoading: true, generalError: const ValueWrapper(null)),
    );
    try {
      await authRepository.signInWithEmail(
        email: event.email,
        password: event.password,
      );
      emit(state.copyWith(isLoading: false, isSuccess: true));
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          generalError: ValueWrapper(e.toString()),
          isSuccess: false,
        ),
      );
    }
  }

  Future<void> _onRegister(
    RegisterWithEmailEvent event,
    Emitter<AuthState> emit,
  ) async {
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
          // Bọc các giá trị lỗi trong ValueWrapper
          nameError: ValueWrapper(nameError),
          emailError: ValueWrapper(emailError),
          passwordError: ValueWrapper(passwordError),
          confirmPasswordError: ValueWrapper(confirmPasswordError),
          generalError: const ValueWrapper(null),
          isSuccess: false,
        ),
      );
      return;
    }

    // Khi bắt đầu loading, cũng nên xóa lỗi chung nếu có
    emit(
      state.copyWith(isLoading: true, generalError: const ValueWrapper(null)),
    );
    try {
      await authRepository.signUpWithEmail(
        name: event.name,
        email: event.email,
        password: event.password,
      );
      emit(state.copyWith(isLoading: false, isSuccess: true));
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          // Bọc lỗi chung trong ValueWrapper
          generalError: ValueWrapper(e.toString()),
          isSuccess: false,
        ),
      );
    }
  }

  Future<void> _onForgot(
    ForgotPasswordEvent event,
    Emitter<AuthState> emit,
  ) async {
    final emailError = Validators.validateEmail(event.email);

    if (emailError != null) {
      emit(
        state.copyWith(emailError: ValueWrapper(emailError), isSuccess: false),
      );
      return;
    }

    emit(
      state.copyWith(isLoading: true, generalError: const ValueWrapper(null)),
    );
    try {
      await authRepository.sendPasswordResetEmail(event.email);
      emit(state.copyWith(isLoading: false, isSuccess: true));
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          generalError: ValueWrapper(e.toString()),
          isSuccess: false,
        ),
      );
    }
  }

  Future<void> _onLogout(Logout event, Emitter<AuthState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      await authRepository.signOut();
      emit(state.copyWith(isLoading: false, isSuccess: true));
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          generalError: ValueWrapper(e.toString()),
          isSuccess: false,
        ),
      );
    }
  }

  Future<void> _onLoginWithGoogle(
    LoginWithGoogle event,
    Emitter<AuthState> emit,
  ) async {
    emit(
      state.copyWith(isLoading: true, generalError: const ValueWrapper(null)),
    );
    try {
      await authRepository.signInWithGoogle();
      emit(state.copyWith(isLoading: false, isSuccess: true));
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          generalError: ValueWrapper(e.toString()),
          isSuccess: false,
        ),
      );
    }
  }
}
