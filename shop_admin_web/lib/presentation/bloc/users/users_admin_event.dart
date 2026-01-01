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
