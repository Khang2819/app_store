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
      return UsersModels.fromFirestore(doc);
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

  Future<Map<String, dynamic>> fetchDashboardMetrics() async {
    final metrics = <String, dynamic>{};
    try {
      final userSnapshot = await _firestore.collection('users').count().get();
      metrics['totalUsers'] = userSnapshot.count.toString();
    } catch (e) {
      metrics['totalUsers'] = 'Lỗi';
    }
    metrics['totalRevenue'] = '₫45M';
    return metrics;
  }

  Future<List<UsersModels>> fetchAllUsers() async {
    try {
      final snapshot = await _firestore.collection('users').get();
      return snapshot.docs
          .map((doc) => UsersModels.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw UserException("Lỗi khi tải danh sách người dùng: ${e.toString()}");
    }
  }

  // update quyền của users á nha
  Future<void> updateUserRole({
    required String userId,
    required String newRole,
  }) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'role': newRole,
      });
    } catch (e) {
      throw Exception('Lỗi cập nhật vai trò: $e');
    }
  }

  Future<void> deleteUsers({required String userId}) async {
    try {
      final userDocRef = _firestore.collection('users').doc(userId);

      // 1. Xóa tất cả các tài liệu trong subcollection 'cart'
      final cartSnapshot = await userDocRef.collection('cart').get();
      final favoritesSnapshot = await userDocRef.collection('favorites').get();

      // Sử dụng Batch Write để xóa nhiều tài liệu hiệu quả
      final batch = _firestore.batch();
      for (var doc in cartSnapshot.docs) {
        batch.delete(doc.reference);
      }
      for (var doc in favoritesSnapshot.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();

      // 2. Xóa tài liệu người dùng chính
      await userDocRef.delete();
    } catch (e) {
      throw Exception('Lỗi xóa người dùng: $e');
    }
  }

  Future<List<UsersModels>> searchUsers(String query) async {
    final snapshot = await _firestore.collection('users').get();
    final allUsers =
        snapshot.docs.map((doc) => UsersModels.fromFirestore(doc)).toList();
    if (query.isEmpty) return allUsers;
    final searchQuery = query.toLowerCase();
    final filteredUsers =
        allUsers.where((user) {
          final name = user.name?.toLowerCase() ?? '';
          final email = user.email?.toLowerCase() ?? '';
          return name.contains(searchQuery) || email.contains(searchQuery);
        }).toList();
    return filteredUsers;
  }
  // repositories/user_repository.dart

  Future<Map<String, int>> getUserStats() async {
    final usersCollection = _firestore.collection('users');

    // Lấy tổng số
    final totalQuery = await usersCollection.count().get();

    // Lấy số lượng Admin
    final adminQuery =
        await usersCollection.where('role', isEqualTo: 'admin').count().get();

    // Lấy số lượng bị cấm (Giả sử bạn dùng trường isBanned: true)
    final bannedQuery =
        await usersCollection.where('isBanned', isEqualTo: true).count().get();

    return {
      'total': totalQuery.count ?? 0,
      'admins': adminQuery.count ?? 0,
      'banned': bannedQuery.count ?? 0,
    };
  }

  Future<void> addUser({
    required String name,
    required String email,
    required String role,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      String? uid = userCredential.user?.uid;

      if (uid != null) {
        await _firestore.collection('users').doc(uid).set({
          'name': name,
          'email': email,
          'role': role,
          'password': password,
          'status': 'active',
          'provider': 'password',
          'createdAt': FieldValue.serverTimestamp(),
          'photoUrl': '',
        });
      }
    } catch (e) {
      throw UserException("Lỗi khi thêm người dùng: ${e.toString()}");
    }
  }
}
