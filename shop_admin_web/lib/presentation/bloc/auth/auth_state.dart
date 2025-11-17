import 'package:equatable/equatable.dart';

class AuthState extends Equatable {
  final String name;
  final String email;
  final String password;
  final String? errorMessage;
  final bool isSuccess;
  final bool isLoading;

  const AuthState({
    this.name = '',
    this.email = '',
    this.password = '',
    this.errorMessage,
    this.isSuccess = false,
    this.isLoading = false,
  });
  AuthState copyWith({
    String? name,
    String? email,
    String? password,
    String? errorMessage,
    bool? isSuccess,
    bool? isLoading,
  }) {
    return AuthState(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      errorMessage: errorMessage ?? this.errorMessage,
      isSuccess: isSuccess ?? this.isSuccess,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [
    name,
    email,
    password,
    errorMessage,
    isSuccess,
    isLoading,
  ];
}
