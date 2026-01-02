import 'package:cloud_firestore/cloud_firestore.dart';

import 'address_model.dart';

class OrderModel {
  final String id;
  final List<OrderItem> items;
  final int totalAmount;
  final String status;
  final DateTime createdAt;
  final String userId;
  final AddressModel address;

  OrderModel({
    required this.id,
    required this.items,
    required this.totalAmount,
    required this.status,
    required this.createdAt,
    required this.address, // THÊM DÒNG NÀY
    required this.userId,
  });

  factory OrderModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return OrderModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      totalAmount: (data['totalAmount'] ?? 0).toInt(),
      status: data['status'] ?? 'đang chờ xử lý',
      // Chuyển đổi Timestamp sang DateTime an toàn
      createdAt:
          data['createdAt'] is Timestamp
              ? (data['createdAt'] as Timestamp).toDate()
              : DateTime.now(),
      // Khởi tạo AddressModel từ Map
      address: AddressModel.fromMap(data['address'] ?? {}),
      // Map danh sách sản phẩm (nếu có)
      items:
          (data['items'] as List?)
              ?.map((item) => OrderItem.fromMap(item))
              .toList() ??
          [],
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
