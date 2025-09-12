import 'package:firebase_auth/firebase_auth.dart';

class AuthException implements Exception {
  final String message;
  AuthException(this.message);

  @override
  String toString() => message;
}

class AuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  Stream<User?> get userChanges => _firebaseAuth.authStateChanges();

  // Đăng nhập bằng email và mật khẩu

  Future<User?> signInWithEmail(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      throw AuthException("Email và mật khẩu không được để trống");
    }
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          throw AuthException("Email không hợp lệ");
        case 'user-disabled':
          throw AuthException("Tài khoản đã bị vô hiệu hóa");
        case 'user-not-found':
          throw AuthException("Không tìm thấy người dùng");
        case 'wrong-password':
          throw AuthException("Mật khẩu không đúng");
        case 'network-request-failed':
          throw AuthException("Lỗi mạng, vui lòng kiểm tra kết nối");
        default:
          throw AuthException("Lỗi không xác định: ${e.message}");
      }
    } catch (e) {
      throw AuthException("Đã xảy ra lỗi không mong muốn..");
    }
  }

  //đăng ký
  Future<User?> signUpWithEmail(
    String name,
    String email,
    String password,
  ) async {
    if (email.isEmpty || password.isEmpty) {
      throw AuthException("Email và mật khẩu không được để trống");
    }
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          throw AuthException("Email đã được sử dụng");
        case 'invalid-email':
          throw AuthException("Email không hợp lệ");
        case 'operation-not-allowed':
          throw AuthException("Không được phép thực hiện thao tác này");
        case 'weak-password':
          throw AuthException("Mật khẩu quá yếu");
        case 'network-request-failed':
          throw AuthException("Lỗi mạng, vui lòng kiểm tra kết nối");
        default:
          throw AuthException("Lỗi không xác định: ${e.message}");
      }
    } catch (e) {
      throw AuthException("Đã xảy ra lỗi không mong muốn..");
    }
  }

  // Đăng xuất
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      throw FirebaseAuthException(
        code: 'sign-out-failed',
        message: "Đăng xuất thất bại",
      );
    }
  }
}
