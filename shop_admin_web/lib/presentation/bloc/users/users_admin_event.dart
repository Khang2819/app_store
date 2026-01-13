import 'package:equatable/equatable.dart';

abstract class UsersAdminEvent extends Equatable {
  const UsersAdminEvent();
  @override
  List<Object> get props => [];
}

class LoadUsers extends UsersAdminEvent {}

class UpdateUsers extends UsersAdminEvent {
  final String userId;
  final String newRole;
  const UpdateUsers(this.userId, this.newRole);
  @override
  List<Object> get props => [];
}

class DeleteUsers extends UsersAdminEvent {
  final String userId;
  const DeleteUsers(this.userId);
  @override
  List<Object> get props => [userId];
}

class SearchUsers extends UsersAdminEvent {
  final String query;
  const SearchUsers(this.query);
  @override
  List<Object> get props => [query];
}

class AddUser extends UsersAdminEvent {
  final String name;
  final String email;
  final String role;
  final String password; // Thêm trường password

  const AddUser({
    required this.name,
    required this.email,
    required this.role,
    required this.password,
  });

  @override
  List<Object> get props => [name, email, role, password];
}

class FilterUsers extends UsersAdminEvent {
  final String status; // 'all', 'user', 'admin', 'banned'
  const FilterUsers(this.status);

  @override
  List<Object> get props => [status];
}
