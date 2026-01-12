import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

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
    final now = DateTime.now();
    final firstDayCurrentMonth = DateTime(now.year, now.month, 1);
    final firstDayLastMonth = DateTime(now.year, now.month - 1, 1);

    // --- 1. XỬ LÝ NGƯỜI DÙNG ---
    final totalUsers = await _firestore.collection('users').count().get();
    final lastMonthUsers =
        await _firestore
            .collection('users')
            .where('createdAt', isGreaterThanOrEqualTo: firstDayLastMonth)
            .where('createdAt', isLessThan: firstDayCurrentMonth)
            .count()
            .get();

    // --- 2. XỬ LÝ ĐƠN HÀNG ---
    final totalOrders = await _firestore.collection('orders').count().get();
    final lastMonthOrders =
        await _firestore
            .collection('orders')
            .where('createdAt', isGreaterThanOrEqualTo: firstDayLastMonth)
            .where('createdAt', isLessThan: firstDayCurrentMonth)
            .count()
            .get();

    // --- 3. XỬ LÝ DOANH THU ---
    final revenueSnapshot =
        await _firestore
            .collection('orders')
            .where(
              'status',
              isEqualTo: 'đã giao hàng',
            ) // Tạm comment dòng này để test xem có lấy được tiền không
            .get();

    double totalRev = 0;
    double lastMonthRev = 0;

    for (var doc in revenueSnapshot.docs) {
      final data = doc.data();
      // Thêm kiểm tra null để tránh lỗi
      final amount = (data['totalAmount'] as num?)?.toDouble() ?? 0.0;
      // Chỉ cộng tiền nếu đơn hàng KHÔNG bị hủy (Logic thực tế)
      final status = data['status'] as String? ?? '';

      if (status != 'đã hủy') {
        final date = (data['createdAt'] as Timestamp?)?.toDate();

        totalRev += amount;
        if (date != null &&
            date.isAfter(firstDayLastMonth) &&
            date.isBefore(firstDayCurrentMonth)) {
          lastMonthRev += amount;
        }
      }
    }

    // Format tiền Việt Nam
    final formatter = NumberFormat("#,###", "vi_VN");

    return {
      'totalUsers': totalUsers.count.toString(),
      'userTrend': calculateTrend(totalUsers.count!, lastMonthUsers.count!),
      'totalOrders': totalOrders.count.toString(),
      'orderTrend': calculateTrend(totalOrders.count!, lastMonthOrders.count!),

      // SỬA: Hiển thị số tiền đầy đủ thay vì chia cho 1 triệu
      'totalRevenue': '${formatter.format(totalRev)} ₫',

      'revenueTrend': calculateTrend(totalRev, lastMonthRev),
    };
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

  Future<List<UsersModels>> fetchUsers() async {
    final snapshot = await _firestore.collection('users').get();
    List<UsersModels> users = [];

    for (var doc in snapshot.docs) {
      // Truy vấn số lượng đơn hàng trong sub-collection của từng user
      final ordersSnapshot =
          await _firestore
              .collection('users')
              .doc(doc.id)
              .collection('orders')
              .get();

      int count = ordersSnapshot.docs.length;

      // Tạo đối tượng user với số lượng đơn hàng thực tế
      Map<String, dynamic> data = doc.data();
      data['orderCount'] = count;

      users.add(
        UsersModels.fromFirestore(doc),
      ); // Đảm bảo hàm fromFirestore đã cập nhật như bước 1
    }
    return users;
  }

  /// Tính toán xu hướng phần trăm giữa giá trị hiện tại và giá trị kỳ trước
  String calculateTrend(num currentValue, num previousValue) {
    if (previousValue == 0) {
      return currentValue > 0 ? '+100%' : '0%';
    }
    final trendPercentage = ((currentValue - previousValue) /
            previousValue *
            100)
        .toStringAsFixed(1);
    final sign = currentValue >= previousValue ? '+' : '';
    return '$sign$trendPercentage%';
  }
}
