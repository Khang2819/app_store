import 'package:equatable/equatable.dart';

class AuthAdminState extends Equatable {
  final String name;
  final String email;
  final String password;
  final String? errorMessage;
  final bool isSuccess;
  final bool isLoading;

  const AuthAdminState({
    this.name = '',
    this.email = '',
    this.password = '',
    this.errorMessage,
    this.isSuccess = false,
    this.isLoading = false,
  });
  AuthAdminState copyWith({
    String? name,
    String? email,
    String? password,
    String? errorMessage,
    bool? isSuccess,
    bool? isLoading,
  }) {
    return AuthAdminState(
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
