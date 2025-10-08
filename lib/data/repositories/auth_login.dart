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
  Future<UserCredential> signInWithEmail({
    required String email,
    required String password,
  }) async {
    return await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // Đăng ký bằng email và mật khẩu
  Future<UserCredential> signUpWithEmail({
    required String name,
    required String email,
    required String password,
  }) async {
    return await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // Đăng xuất
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
