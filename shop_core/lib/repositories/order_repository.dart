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
      'status': 'completed',
      'createdAt': FieldValue.serverTimestamp(),
    };

    // 2. Tạo reference cho đơn hàng mới
    final orderRef =
        _firestore.collection('users').doc(user.uid).collection('orders').doc();
    batch.set(orderRef, orderData);

    // 3. Chuẩn bị xóa giỏ hàng sau khi đặt thành công
    final cartSnapshot =
        await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('cart')
            .get();

    for (var doc in cartSnapshot.docs) {
      batch.delete(doc.reference);
    }

    // 4. Thực thi tất cả lệnh trong một lần (Atomic)
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
}
