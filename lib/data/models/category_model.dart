import 'package:cloud_firestore/cloud_firestore.dart';

class Category {
  final String id;
  final Map<String, dynamic> name;
  final String imageUrl;

  const Category({
    required this.id,
    required this.name,
    required this.imageUrl,
  });
  factory Category.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Category(
      id: doc.id,
      name: data['name'] as Map<String, dynamic>? ?? const {},
      imageUrl: data['imageUrl'] ?? '',
    );
  }
}
