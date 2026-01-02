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
                      item.product.name['vi'] ?? item.product.name['en'],
                  'quantity': item.quantity,
                  'price': item.product.price,
                  'imageUrl': item.product.imageUrl,
                },
              )
              .toList(),
      'totalAmount': totalAmount,
      'address': address.toMap(),
      'status': 'pending',
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

    final batch = _firestore.batch();

    final userOrderRef = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('orders')
        .doc(orderId);
    batch.delete(userOrderRef);

    final adminOrderRef = _firestore.collection('orders').doc(orderId);
    batch.delete(adminOrderRef);

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
}
