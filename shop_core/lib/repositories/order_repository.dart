import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/order_model.dart';
import '../shop_core.dart';

class OrderRepository {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Future<List<OrderModel>> fetchOrderHistory() async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('Người dùng chưa đăng nhập');

    final snapshot =
        await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('orders')
            .orderBy('createdAt', descending: true)
            .get();

    return snapshot.docs.map((doc) => OrderModel.fromFirestore(doc)).toList();
  }

  Future<void> createOrder({
    required List<CartItem> items,
    required int totalAmount,
    required AddressModel address,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('Người dùng chưa đăng nhập');

    final batch = _firestore.batch();

    // 1. Chuẩn bị dữ liệu đơn hàng
    final orderData = {
      'userId': user.uid,
      'items':
          items
              .map(
                (item) => {
                  'productId': item.product.id,
                  'productName':
                      item.product.name['vi'] ??
                      item.product.name['en'] ??
                      item.product.name['ja'],
                  'quantity': item.quantity,
                  'price': item.product.price,
                  'imageUrl': item.product.imageUrl,
                },
              )
              .toList(),
      'totalAmount': totalAmount,
      'address': address.toMap(),
      'status': 'đang chờ xử lý',
      'createdAt': FieldValue.serverTimestamp(),
    };

    // 2. Tạo reference cho đơn hàng mới
    final orderRef =
        _firestore.collection('users').doc(user.uid).collection('orders').doc();
    batch.set(orderRef, orderData);

    final adminOrderRef = _firestore.collection('orders').doc(orderRef.id);
    batch.set(adminOrderRef, orderData);

    // 3. Cập nhật soldCount cho từng sản phẩm
    for (var item in items) {
      final productRef = _firestore.collection('products').doc(item.product.id);
      batch.update(productRef, {
        'soldCount': FieldValue.increment(item.quantity),
      });
    }
    final userRef = _firestore.collection('users').doc(user.uid);
    batch.update(userRef, {'orderCount': FieldValue.increment(1)});

    // 4. Chuẩn bị xóa giỏ hàng sau khi đặt thành công
    final cartSnapshot =
        await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('cart')
            .get();

    for (var doc in cartSnapshot.docs) {
      batch.delete(doc.reference);
    }

    // 5. Thực thi tất cả lệnh trong một lần (Atomic)
    await batch.commit();
  }

  Future<void> deleteOrder(String orderId) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('Người dùng chưa đăng nhập');

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('orders')
        .doc(orderId)
        .delete();
  }

  Future<void> deleteOrderAdmin(String orderId, String userId) async {
    final batch = _firestore.batch();

    // Xóa trong danh sách tổng của Admin (Mất doanh thu từ đơn này)
    final adminOrderRef = _firestore.collection('orders').doc(orderId);
    batch.delete(adminOrderRef);

    // Xóa luôn trong lịch sử User để đồng bộ
    if (userId.isNotEmpty) {
      final userOrderRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('orders')
          .doc(orderId);
      batch.delete(userOrderRef);
    }

    await batch.commit();
  }

  // Lấy tất cả đơn hàng cho Admin (Web)
  Future<List<OrderModel>> fetchAllOrdersForAdmin() async {
    final snapshot =
        await _firestore
            .collection('orders')
            .orderBy('createdAt', descending: true)
            .get();

    return snapshot.docs.map((doc) => OrderModel.fromFirestore(doc)).toList();
  }

  Future<void> updateOrderStatus(
    String userId,
    String orderId,
    String status,
  ) async {
    final batch = _firestore.batch();

    // Cập nhật cho User
    final userOrderRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('orders')
        .doc(orderId);
    batch.update(userOrderRef, {'status': status});

    // Cập nhật cho danh sách tổng của Admin
    final adminOrderRef = _firestore.collection('orders').doc(orderId);
    batch.update(adminOrderRef, {'status': status});

    await batch.commit();
  }

  // Trong class OrderRepository
  Future<List<Map<String, dynamic>>> getMonthlyRevenue() async {
    final now = DateTime.now();
    final currentYear = now.year;

    // Lấy tất cả đơn hàng đã hoàn thành trong năm nay
    // Lưu ý: Trong thực tế nên query theo range date để tối ưu, ở đây lấy hết để đơn giản
    final snapshot =
        await _firestore
            .collection('orders')
            .where(
              'status',
              isEqualTo: 'đã giao hàng',
            ) // Chỉ tính đơn đã hoàn thành
            .get();

    // Khởi tạo map doanh thu cho 12 tháng
    Map<int, double> monthlyRevenue = {for (var i = 1; i <= 12; i++) i: 0.0};

    for (var doc in snapshot.docs) {
      final data = doc.data();
      final createdAt = (data['createdAt'] as Timestamp).toDate();
      final amount = (data['totalAmount'] as num).toDouble();

      if (createdAt.year == currentYear) {
        monthlyRevenue[createdAt.month] =
            (monthlyRevenue[createdAt.month] ?? 0) + amount;
      }
    }

    // Chuyển đổi sang format List để Bloc sử dụng
    List<Map<String, dynamic>> result = [];
    monthlyRevenue.forEach((month, value) {
      result.add({'month': 'T$month', 'value': value});
    });

    return result;
  }

  Future<List<OrderModel>> searchOrders(String query) async {
    final snapshot =
        await _firestore
            .collection('orders')
            .orderBy('createdAt', descending: true)
            .get();

    final allOrders =
        snapshot.docs.map((doc) => OrderModel.fromFirestore(doc)).toList();

    if (query.isEmpty) {
      return allOrders;
    }

    final lowerQuery = query.toLowerCase().trim();

    return allOrders.where((order) {
      final idMatch = order.id.toLowerCase().contains(lowerQuery);
      final nameMatch = order.address.fullName.toLowerCase().contains(
        lowerQuery,
      );
      final phoneMatch = order.address.phoneNumber.contains(lowerQuery);

      return idMatch || nameMatch || phoneMatch;
    }).toList();
  }
}
