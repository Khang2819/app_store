import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthException implements Exception {
  final String message;
  AuthException(this.message);

  @override
  String toString() => message;
}

class AuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<User?> get userChanges => _firebaseAuth.authStateChanges();

  // Đăng nhập bằng email và mật khẩu
  Future<UserCredential> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      return await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw AuthException(_mapFirebaseErrorToMessage(e.code));
    }
  }

  // Đăng ký bằng email và mật khẩu
  Future<UserCredential> signUpWithEmail({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      final User? firebaseUser = userCredential.user;
      if (firebaseUser != null) {
        await _firestore.collection('users').doc(firebaseUser.uid).set({
          'name': name,
          'email': email,
          'createdAt': Timestamp.now(),
          'provider': 'email',
        });
      }
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw AuthException(_mapFirebaseErrorToMessage(e.code));
    }
  }

  Future<UserCredential> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw AuthException('Đăng nhập Google đã bị hủy.');
      }
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final UserCredential userCredential = await _firebaseAuth
          .signInWithCredential(credential);
      final User? firebaseUser = userCredential.user;
      if (firebaseUser != null) {
        final userDoc = _firestore.collection('users').doc(firebaseUser.uid);
        final docSnapshot = await userDoc.get();
        if (!docSnapshot.exists) {
          await userDoc.set({
            'name': firebaseUser.displayName, // Lấy tên từ tài khoản Google
            'email': firebaseUser.email, // Lấy email từ tài khoản Google
            'photoUrl': firebaseUser.photoURL, // Lấy ảnh đại diện
            'createdAt': Timestamp.now(),
            'provider': 'google', // Thêm thông tin nhà cung cấp
          });
        }
      }
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw AuthException(_mapFirebaseErrorToMessage(e.code));
    } catch (e) {
      throw AuthException('Đã có lỗi xảy ra khi đăng nhập với Google.');
    }
  }

  // Gửi email đặt lại mật khẩu
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw AuthException(_mapFirebaseErrorToMessage(e.code));
    }
  }

  // Đăng xuất
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    await _googleSignIn.signOut();
  }

  String _mapFirebaseErrorToMessage(String code) {
    switch (code) {
      case 'invalid-credential':
      case 'user-not-found':
      case 'wrong-password':
        return 'Email hoặc mật khẩu không chính xác.';
      case 'email-already-in-use':
        return 'Địa chỉ email này đã được sử dụng.';
      case 'weak-password':
        return 'Mật khẩu quá yếu.';
      case 'invalid-email':
        return 'Địa chỉ email không hợp lệ.';
      default:
        return 'Đã có lỗi xảy ra. Vui lòng thử lại.';
    }
  }
}
