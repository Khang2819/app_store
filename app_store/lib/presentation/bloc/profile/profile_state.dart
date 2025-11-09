import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileState extends Equatable {
  final bool isLoading;
  final User? user;
  final String? avatarUrl;
  final String? error;

  const ProfileState({
    this.isLoading = false,
    this.user,
    this.avatarUrl,
    this.error,
  });

  ProfileState copyWith({
    bool? isLoading,
    User? user,
    String? avatarUrl,
    String? error,
  }) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      error: error,
    );
  }

  @override
  List<Object?> get props => [isLoading, user, avatarUrl, error];
}
