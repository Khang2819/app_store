import 'package:equatable/equatable.dart';
import 'package:shop_core/shop_core.dart';

class AuthState extends Equatable {
  final String name;
  final String email;
  final String password;
  final String confirmPassword;
  final bool isLoading;
  final bool isSuccess;

  final String? nameError;
  final String? emailError;
  final String? passwordError;
  final String? confirmPasswordError;
  final String? generalError;

  const AuthState({
    this.name = '',
    this.email = '',
    this.password = '',
    this.confirmPassword = '',
    this.isLoading = false,
    this.isSuccess = false,

    this.nameError,
    this.emailError,
    this.passwordError,
    this.confirmPasswordError,
    this.generalError,
  });
  AuthState copyWith({
    String? name,
    String? email,
    String? password,
    String? confirmPassword,
    bool? isLoading,
    bool? isSuccess,
    ValueWrapper<String?>? nameError,
    ValueWrapper<String?>? emailError,
    ValueWrapper<String?>? passwordError,
    ValueWrapper<String?>? confirmPasswordError,
    ValueWrapper<String?>? generalError,
  }) {
    return AuthState(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      nameError: nameError != null ? nameError.value : this.nameError,
      emailError: emailError != null ? emailError.value : this.emailError,
      passwordError:
          passwordError != null ? passwordError.value : this.passwordError,
      confirmPasswordError:
          confirmPasswordError != null
              ? confirmPasswordError.value
              : this.confirmPasswordError,
      generalError:
          generalError != null ? generalError.value : this.generalError,
    );
  }

  @override
  List<Object?> get props => [
    name,
    email,
    password,
    confirmPassword,
    isLoading,
    isSuccess,
    nameError,
    emailError,
    passwordError,
    confirmPasswordError,
    generalError,
  ];
}
