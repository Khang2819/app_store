import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_core/shop_core.dart';

import 'users_admin_event.dart';
import 'users_admin_state.dart';

class UsersAdminBloc extends Bloc<UsersAdminEvent, UsersAdminState> {
  final UserRepository userRepository;
  UsersAdminBloc({required this.userRepository})
    : super(const UsersAdminState()) {
    on<LoadUsers>(_onLoadUsers);
    on<UpdateUsers>(_onUpdateUsers);
    on<DeleteUsers>(_onDeleteUsers);
    on<SearchUsers>(_onSearchUsers);
    on<AddUser>(_onAddUser);
    on<FilterUsers>(_onFilterUsers);
  }

  Future<void> _onLoadUsers(
    LoadUsers event,
    Emitter<UsersAdminState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final users = await userRepository.fetchAllUsers();
      final total = users.length;
      final admins = users.where((u) => u.role == 'admin').length;
      final banned = users.where((u) => u.role == 'banned').length;
      emit(
        state.copyWith(
          isLoading: false,
          allUsers: users,
          users: users,
          totalCount: total,
          adminCount: admins,
          bannedCount: banned,
          errorMessage: null,
          filterStatus: 'all',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Không thể tải danh sách người dùng: ${e.toString()}',
        ),
      );
    }
  }

  void _onFilterUsers(FilterUsers event, Emitter<UsersAdminState> emit) {
    final status = event.status;
    List<UsersModels> filteredList;

    if (status == 'all') {
      filteredList = state.allUsers;
    } else {
      // Lọc theo role khớp với status ('user', 'admin', 'banned')
      filteredList = state.allUsers.where((u) => u.role == status).toList();
    }

    emit(state.copyWith(users: filteredList, filterStatus: status));
  }

  Future<void> _onUpdateUsers(
    UpdateUsers event,
    Emitter<UsersAdminState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      await userRepository.updateUserRole(
        userId: event.userId,
        newRole: event.newRole,
      );
      final updateUsers = await userRepository.fetchAllUsers();
      emit(
        state.copyWith(
          isLoading: false,
          users: updateUsers,
          errorMessage: null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isActionLoading: false,
          errorMessage: 'Lỗi không xác định khi cập nhật: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onDeleteUsers(
    DeleteUsers event,
    Emitter<UsersAdminState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      await userRepository.deleteUsers(userId: event.userId);
      final deleteUsers = await userRepository.fetchAllUsers();
      emit(
        state.copyWith(
          isLoading: false,
          users: deleteUsers,
          errorMessage: null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isActionLoading: false,
          errorMessage: 'Lỗi không xác định khi cập nhật: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onSearchUsers(
    SearchUsers event,
    Emitter<UsersAdminState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final searchUsers = await userRepository.searchUsers(event.query);
      emit(
        state.copyWith(
          isLoading: false,
          users: searchUsers,
          errorMessage: null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isActionLoading: false,
          errorMessage: 'Lỗi không tìm kiếm được người dùng',
        ),
      );
    }
  }

  Future<void> _onAddUser(AddUser event, Emitter<UsersAdminState> emit) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      await userRepository.addUser(
        name: event.name,
        email: event.email,
        role: event.role,
        password: event.password, // Truyền mật khẩu từ event
      );

      // Tải lại danh sách bằng hàm fetchAllUsers đã có trong repo của bạn
      final users = await userRepository.fetchAllUsers();
      emit(state.copyWith(isLoading: false, users: users, errorMessage: null));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }
}
