import 'package:equatable/equatable.dart';

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
    String? nameError,
    String? emailError,
    String? passwordError,
    String? confirmPasswordError,
    String? generalError,
  }) {
    return AuthState(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      nameError: nameError,
      emailError: emailError,
      passwordError: passwordError,
      confirmPasswordError: confirmPasswordError,
      generalError: generalError,
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
