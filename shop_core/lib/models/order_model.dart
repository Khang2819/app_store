import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  final String id;
  final List<OrderItem> items;
  final int totalAmount;
  final String status;
  final Timestamp createdAt;

  OrderModel({
    required this.id,
    required this.items,
    required this.totalAmount,
    required this.status,
    required this.createdAt,
  });

  factory OrderModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return OrderModel(
      id: doc.id,
      totalAmount: data['totalAmount'] ?? 0,
      status: data['status'] ?? 'pending',
      createdAt: data['createdAt'] ?? Timestamp.now(),
      items:
          (data['items'] as List)
              .map((item) => OrderItem.fromMap(item))
              .toList(),
    );
  }
}

class OrderItem {
  final String productId;
  final String productName;
  final int quantity;
  final int price;
  final String imageUrl;

  OrderItem({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.price,
    required this.imageUrl,
  });

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      productId: map['productId'] ?? '',
      productName: map['productName'] ?? '',
      quantity: map['quantity'] ?? 0,
      price: map['price'] ?? 0,
      imageUrl: map['imageUrl'] ?? '',
    );
  }
}
