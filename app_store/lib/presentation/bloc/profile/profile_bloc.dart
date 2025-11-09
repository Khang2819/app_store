import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_core/shop_core.dart';
import 'profile_state.dart';
import 'profile_event.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UserRepository _userRepository;
  ProfileBloc(this._userRepository) : super(ProfileState()) {
    on<LoadProfile>(_onLoadProfile);
    on<UpdateProfile>(_onUpdateProfile);
    on<UploadAvatar>(_onUploadAvatar);
  }

  Future<void> _onLoadProfile(
    LoadProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final authUser = FirebaseAuth.instance.currentUser;
      if (authUser == null) {
        throw AuthException('Người dùng chưa đăng nhập');
      }
      await authUser.reload();
      final freshUser = FirebaseAuth.instance.currentUser;
      emit(
        state.copyWith(
          isLoading: false,
          user: freshUser,
          avatarUrl: freshUser?.photoURL,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onUpdateProfile(
    UpdateProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final authUser = FirebaseAuth.instance.currentUser;
      if (authUser == null) throw AuthException('Chưa xác thực.');
      await _userRepository.updateProfile(name: event.name);
      add(LoadProfile());
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onUploadAvatar(
    UploadAvatar event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      // 5. Gọi repository để tải avatar lên
      await _userRepository.uploadAvatar(event.imageFile);
      // 6. Tải lại profile để cập nhật UI (lấy photoURL mới)
      add(LoadProfile());
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }
}
