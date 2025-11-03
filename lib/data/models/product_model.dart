import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final Map<String, dynamic> name;
  final String imageUrl;
  final int price;
  final Map<String, dynamic> description;
  final String categoryId;
  Product({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.description,
    required this.categoryId,
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
    );
  }
}
