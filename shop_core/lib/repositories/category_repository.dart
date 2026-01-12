import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/category_model.dart';

class CategoryRepository {
  final _firestore = FirebaseFirestore.instance;

  Future<List<Category>> fetchCategories() async {
    final snapshot = await _firestore.collection('categories').get();
    // Trả về một List<Product> thay vì List<Map>
    return snapshot.docs.map((doc) => Category.fromFirestore(doc)).toList();
  }

  Future<void> addCategory({
    required Map<String, String> names,
    required String imageUrl,
  }) async {
    await _firestore.collection('categories').add({
      'name': names,
      'imageUrl': imageUrl,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateCategory({
    required String categoryId,
    required Map<String, String> names,
    required String imageUrl,
  }) async {
    await _firestore.collection('categories').doc(categoryId).update({
      'name': names,
      'imageUrl': imageUrl,
    });
  }

  Future<void> fetchDeleteCategory({required String categoryId}) async {
    await _firestore.collection('categories').doc(categoryId).delete();
  }
}
