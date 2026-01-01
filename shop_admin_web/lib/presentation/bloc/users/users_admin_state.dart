import 'package:equatable/equatable.dart';
import 'package:shop_core/shop_core.dart';

class UsersAdminState extends Equatable {
  final bool isLoading;
  final String? errorMessage;
  final List<UsersModels> users;
  final bool isActionLoading;
  final int totalCount;
  final int adminCount;
  final int bannedCount;

  const UsersAdminState({
    this.isLoading = true,
    this.errorMessage,
    this.users = const [],
    this.isActionLoading = false,
    this.totalCount = 0, // Mặc định là 0
    this.adminCount = 0,
    this.bannedCount = 0,
  });
  UsersAdminState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<UsersModels>? users,
    bool? isActionLoading,
    int? totalCount,
    int? adminCount,
    int? bannedCount,
  }) {
    return UsersAdminState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      users: users ?? this.users,
      isActionLoading: isActionLoading ?? this.isActionLoading,
      totalCount: totalCount ?? this.totalCount,
      adminCount: adminCount ?? this.adminCount,
      bannedCount: bannedCount ?? this.bannedCount,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    errorMessage,
    users,
    isActionLoading,
    totalCount,
    adminCount,
    bannedCount,
  ];
}
