import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../shop_core.dart';

class CartRepository {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Future<List<CartItem>> fetchCart() async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('Người dùng chưa đăng nhập');
    }

    final cartSnapshot =
        await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('cart')
            .get();

    if (cartSnapshot.docs.isEmpty) {
      return [];
    }

    List<CartItem> cartItems = [];
    for (var cartDoc in cartSnapshot.docs) {
      final data = cartDoc.data();
      final productId = data['productId'] as String;
      final quantity = data['quantity'] as int;

      // Lấy thông tin chi tiết sản phẩm
      final productDoc =
          await _firestore.collection('products').doc(productId).get();

      if (productDoc.exists) {
        cartItems.add(
          CartItem(
            product: Product.fromFirestore(productDoc),
            quantity: quantity,
          ),
        );
      }
    }
    return cartItems;
  }

  Future<void> removeFromCart(String productId) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('cart')
        .doc(productId)
        .delete();
  }

  Future<void> updateQuantity(String productId, int newQuantity) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final docRef = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('cart')
        .doc(productId);

    if (newQuantity <= 0) {
      // Nếu số lượng <= 0, xóa sản phẩm khỏi giỏ hàng
      await docRef.delete();
    } else {
      // Cập nhật số lượng mới
      await docRef.update({'quantity': newQuantity});
    }
  }
}
