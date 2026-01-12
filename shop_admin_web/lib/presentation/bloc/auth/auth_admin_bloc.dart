import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_core/shop_core.dart';
import 'auth_admin_event.dart';
import 'auth_admin_state.dart';

class AuthAdminBloc extends Bloc<AuthAdminEvent, AuthAdminState> {
  final AuthRepository authRepository;
  AuthAdminBloc(this.authRepository) : super(const AuthAdminState()) {
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthAdminState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final UserCredential userCredential = await authRepository
          .signInWithEmail(email: event.email, password: event.password);
      final String? uid = userCredential.user?.uid;
      if (uid == null) {
        throw Exception("Không thể lấy UID người dùng sau khi đăng nhập.");
      }
      final UsersModels user = await authRepository.getAdminUserModel(uid);

      if (user.role == 'admin') {
        emit(
          state.copyWith(isLoading: false, isSuccess: true, errorMessage: null),
        );
      } else {
        emit(
          state.copyWith(
            isLoading: false,
            isSuccess: false,
            errorMessage:
                'Tài khoản không có quyền quản trị. Vui lòng sử dụng tài khoản Admin.',
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      // Xử lý lỗi từ Firebase (ví dụ: Sai mật khẩu)
      emit(state.copyWith(isLoading: false, errorMessage: e.message));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthAdminState> emit,
  ) async {
    try {
      // Gọi hàm đăng xuất từ repository nếu có (ví dụ: FirebaseAuth.instance.signOut())
      await authRepository.signOut();
      emit(const AuthAdminState()); // Reset về state ban đầu (unauthenticated)
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }
}
