import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../models/users_model.dart';

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
        await firebaseUser.updateProfile(displayName: name);
        final newUser = UsersModels(
          id: firebaseUser.uid,
          name: name,
          email: email,
          createdAt: Timestamp.now(),
          provider: 'email',
          photoUrl: null,
        );
        await _firestore
            .collection('users')
            .doc(firebaseUser.uid)
            .set(newUser.toMap());
      }
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw AuthException(_mapFirebaseErrorToMessage(e.code));
    }
  }

  Future<UserCredential> signInWithGoogle() async {
    try {
      await _googleSignIn.signOut();
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw AuthException('google_sign_in_cancelled');
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
          final newUser = UsersModels(
            id: firebaseUser.uid,
            name: firebaseUser.displayName,
            email: firebaseUser.email,
            photoUrl: firebaseUser.photoURL,
            createdAt: Timestamp.now(),
            provider: 'Google',
          );
          await userDoc.set(newUser.toMap());
        }
      }
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw AuthException(_mapFirebaseErrorToMessage(e.code));
    } catch (e) {
      throw AuthException('google_sign_in_failed');
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
        return 'invalid_credential';
      case 'email-already-in-use':
        return 'email_already_in_use';
      case 'weak-password':
        return 'weak_password';
      case 'invalid-email':
        return 'invalid_email';
      default:
        return 'unknown_error';
    }
  }
}
