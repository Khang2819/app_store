import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoginWithEmailEvent extends AuthEvent {
  final String email;
  final String password;

  LoginWithEmailEvent({required this.email, required this.password});
  @override
  List<Object?> get props => [email, password];
}

class ForgotPasswordEvent extends AuthEvent {
  final String email;

  ForgotPasswordEvent({required this.email});
  @override
  List<Object?> get props => [email];
}

class RegisterWithEmailEvent extends AuthEvent {
  final String name;
  final String email;
  final String password;
  final String confirmPassword;

  RegisterWithEmailEvent({
    required this.name,
    required this.email,
    required this.password,
    required this.confirmPassword,
  });
  @override
  List<Object?> get props => [name, email, password, confirmPassword];
}

class EmailChanged extends AuthEvent {
  final String email;
  EmailChanged(this.email);
  @override
  List<Object?> get props => [email];
}

class PasswordChanged extends AuthEvent {
  final String password;
  PasswordChanged(this.password);
  @override
  List<Object?> get props => [password];
}

class NameChanged extends AuthEvent {
  final String name;
  NameChanged(this.name);
  @override
  List<Object?> get props => [name];
}

class ConfirmPasswordChanged extends AuthEvent {
  final String confirmPassword;
  ConfirmPasswordChanged(this.confirmPassword);
  @override
  List<Object?> get props => [confirmPassword];
}

class ClearAuthStatus extends AuthEvent {}

class Logout extends AuthEvent {}
