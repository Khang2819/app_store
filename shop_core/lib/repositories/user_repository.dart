import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

import '../models/users_model.dart';

// Lớp Exception tùy chỉnh cho các lỗi liên quan đến User
class UserException implements Exception {
  final String message;
  UserException(this.message);

  @override
  String toString() => message;
}

class UserRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// Lấy thông tin chi tiết của người dùng hiện tại từ Firestore
  Future<UsersModels> getUserDetails() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      throw UserException("Người dùng chưa đăng nhập.");
    }
    try {
      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (!doc.exists) {
        throw UserException("Không tìm thấy thông tin người dùng.");
      }
      return UsersModels.fromMap(doc.data()!);
    } catch (e) {
      throw UserException("Lỗi khi lấy thông tin người dùng: ${e.toString()}");
    }
  }

  /// Cập nhật thông tin hồ sơ người dùng (ví dụ: tên)
  Future<void> updateProfile({required String name}) async {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      throw UserException("Người dùng chưa đăng nhập.");
    }
    try {
      // Cập nhật tên trong Firebase Auth
      await user.updateDisplayName(name);

      // Cập nhật tên trong Firestore
      await _firestore.collection('users').doc(user.uid).update({'name': name});
    } catch (e) {
      throw UserException("Lỗi khi cập nhật hồ sơ: ${e.toString()}");
    }
  }

  /// Tải ảnh đại diện lên Firebase Storage và cập nhật URL trong Firestore
  Future<String> uploadAvatar(XFile imageFile) async {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      throw UserException("Người dùng chưa đăng nhập.");
    }

    try {
      // 1. Tạo đường dẫn lưu trữ
      final fileExtension = imageFile.path.split('.').last;
      final storagePath = 'avatars/${user.uid}.$fileExtension';
      final storageRef = _storage.ref().child(storagePath);

      // 2. Tải tệp lên
      final uploadTask = await storageRef.putData(
        await imageFile.readAsBytes(),
      );

      // 3. Lấy URL tải về
      final downloadUrl = await uploadTask.ref.getDownloadURL();

      // 4. Cập nhật URL trong Firebase Auth
      await user.updatePhotoURL(downloadUrl);

      // 5. Cập nhật URL trong Firestore
      await _firestore.collection('users').doc(user.uid).update({
        'photoUrl': downloadUrl,
      });

      return downloadUrl;
    } on FirebaseException catch (e) {
      throw UserException("Lỗi khi tải ảnh lên: ${e.message}");
    } catch (e) {
      throw UserException("Đã xảy ra lỗi không mong muốn: ${e.toString()}");
    }
  }
}
