import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String name;
  final String imageUrl;
  final int price;
  final String description;
  Product({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.description,
  });
  factory Product.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Product(
      id: doc.id,
      name: data['name'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      price: (data['price'] ?? 0).toInt(),
      description: data['description'] ?? '',
    );
  }
}
