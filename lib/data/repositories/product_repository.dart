import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/product_model.dart';

class ProductRepository {
  final _firestore = FirebaseFirestore.instance;

  Future<List<Product>> fetchProducts() async {
    final snapshot = await _firestore.collection('products').get();
    // Trả về một List<Product> thay vì List<Map>
    return snapshot.docs.map((doc) => Product.fromFirestore(doc)).toList();
  }

  Future<List<Product>> fetchCategories() async {
    final snapshot = await _firestore.collection('categories').get();
    // Trả về một List<Product> thay vì List<Map>
    return snapshot.docs.map((doc) => Product.fromFirestore(doc)).toList();
  }
}
