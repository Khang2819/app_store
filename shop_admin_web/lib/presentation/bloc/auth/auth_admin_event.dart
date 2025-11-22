import 'package:equatable/equatable.dart';

abstract class AuthAdminEvent extends Equatable {
  const AuthAdminEvent();

  @override
  List<Object?> get props => [];
}

class LoginRequested extends AuthAdminEvent {
  final String email;
  final String password;

  const LoginRequested(this.email, this.password);

  @override
  List<Object?> get props => [email, password];
}

class LogoutRequested extends AuthAdminEvent {}
