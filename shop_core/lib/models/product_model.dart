import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final Map<String, dynamic> name;
  final String imageUrl;
  final int price;
  final Map<String, dynamic> description;
  final String categoryId;
  final double averageRating; // <<<<< THÊM MỚI
  final int reviewCount;
  final Timestamp? createdAt;
  final int soldCount;

  Product({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.description,
    required this.categoryId,
    this.averageRating = 0.0,
    this.reviewCount = 0,
    this.createdAt,
    this.soldCount = 0,
  });
  factory Product.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Product(
      id: doc.id,
      name: data['name'] as Map<String, dynamic>? ?? const {},
      imageUrl: data['imageUrl'] ?? '',
      categoryId: data['categoryId'] ?? '',
      price: (data['price'] ?? 0).toInt(),
      description: data['description'] as Map<String, dynamic>? ?? const {},
      // Đảm bảo ép kiểu double/int chính xác
      averageRating: (data['averageRating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: (data['reviewCount'] as num?)?.toInt() ?? 0,
      soldCount: (data['soldCount'] as num?)?.toInt() ?? 0,
      createdAt: data['createdAt'] as Timestamp?,
    );
  }
}
