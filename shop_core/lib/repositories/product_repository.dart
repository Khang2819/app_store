import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/category_model.dart';
import '../models/product_model.dart';
import '../models/review_model.dart';

class ProductRepository {
  final _firestore = FirebaseFirestore.instance;

  Future<List<Product>> fetchProducts() async {
    final snapshot = await _firestore.collection('products').get();
    // Trả về một List<Product> thay vì List<Map>
    return snapshot.docs.map((doc) => Product.fromFirestore(doc)).toList();
  }

  Future<List<Category>> fetchCategories() async {
    final snapshot = await _firestore.collection('categories').get();
    // Trả về một List<Product> thay vì List<Map>
    return snapshot.docs.map((doc) => Category.fromFirestore(doc)).toList();
  }

  // Lấy chi tiết một sản phẩm
  Future<Product> fetchProduct(String productId) async {
    final doc = await _firestore.collection('products').doc(productId).get();
    return Product.fromFirestore(doc);
  }

  // lấy danh sách sản phẩm mới nhất
  Future<List<Product>> fetchLatestProducts() async {
    final snapshot =
        await _firestore
            .collection('products')
            .orderBy('createdAt', descending: true)
            .limit(10)
            .get();
    return snapshot.docs.map((doc) => Product.fromFirestore(doc)).toList();
  }

  // lấy số lượng sản phẩm được bán
  Future<List<Product>> fetchBestsellingProducts() async {
    final snapshot =
        await _firestore
            .collection('products')
            .orderBy('soldCount', descending: true)
            .limit(10)
            .get();
    return snapshot.docs.map((doc) => Product.fromFirestore(doc)).toList();
  }

  Future<List<String>> fetchFavorites(String userId) async {
    final snapshot =
        await _firestore
            .collection('users')
            .doc(userId)
            .collection('favorites')
            .get();
    return snapshot.docs.map((doc) => doc.id).toList();
  }

  Future<void> toggleFavorite({
    required String userId,
    required String productId,
    required bool isAdding,
  }) async {
    final favoritesRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('favorites');

    final favoriteDoc = favoritesRef.doc(productId);

    if (isAdding) {
      await favoriteDoc.set({'addedAt': FieldValue.serverTimestamp()});
    } else {
      await favoriteDoc.delete();
    }
  }

  Future<List<Product>> fetchProductsByIds(List<String> productIds) async {
    if (productIds.isEmpty) return [];
    final uniqueIds = productIds.toSet().toList();
    final idsToFetch = uniqueIds.take(10).toList();
    final snapshot =
        await _firestore
            .collection('products')
            .where(FieldPath.documentId, whereIn: idsToFetch)
            .get();
    return snapshot.docs.map((doc) => Product.fromFirestore(doc)).toList();
  }

  // Lấy danh sách đánh giá của sản phẩm
  Future<List<Review>> fetchReviews(String productId) async {
    final snapshot =
        await _firestore
            .collection('products')
            .doc(productId)
            .collection('reviews')
            .orderBy('timestamp', descending: true)
            .get();
    return snapshot.docs.map((doc) => Review.fromFirestore(doc)).toList();
  }

  // Thêm đánh giá mới
  Future<void> addReview({
    required String productId,
    required String userId,
    required String userName,
    required double rating,
    required String comment,
  }) async {
    await _firestore
        .collection('products')
        .doc(productId)
        .collection('reviews')
        .add({
          'userId': userId,
          'userName': userName,
          'rating': rating,
          'comment': comment,
          'timestamp': FieldValue.serverTimestamp(),
        });
    final reviewsSnapshot =
        await _firestore
            .collection('products')
            .doc(productId)
            .collection('reviews')
            .get();

    final reviews = reviewsSnapshot.docs;
    final int totalReviews = reviews.length;

    // Tính trung bình cộng của các rating
    final double averageRating =
        reviews.fold(0.0, (sum, doc) => sum + (doc['rating'] as num)) /
        totalReviews;

    // 3. Cập nhật ngược lại vào tài liệu Product
    await _firestore.collection('products').doc(productId).update({
      'averageRating': double.parse(
        averageRating.toStringAsFixed(1),
      ), // Làm tròn 1 chữ số thập phân
      'reviewCount': totalReviews,
    });
  }

  // Thêm vào giỏ hàng
  Future<void> addToCart({
    required String userId,
    required String productId,
    required int quantity,
  }) async {
    final cartRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('cart')
        .doc(productId);

    final doc = await cartRef.get();
    if (doc.exists) {
      // Nếu sản phẩm đã có trong giỏ, cập nhật số lượng
      await cartRef.update({'quantity': FieldValue.increment(quantity)});
    } else {
      // Nếu chưa có, thêm mới
      await cartRef.set({
        'productId': productId,
        'quantity': quantity,
        'addedAt': FieldValue.serverTimestamp(),
      });
    }
  }

  Future<bool> checkIfUserPurchasedProduct({
    required String userId,
    required String productId,
  }) async {
    try {
      // 1. Lấy tất cả đơn hàng đã hoàn thành của người dùng
      final ordersSnapshot =
          await _firestore
              .collection('users')
              .doc(userId)
              .collection('orders')
              .where('status', isEqualTo: 'completed') // Chỉ tính đơn đã xong
              .get();

      // 2. Duyệt qua từng đơn hàng (document)
      for (var doc in ordersSnapshot.docs) {
        final data = doc.data();
        final List items = data['items'] as List? ?? [];

        // 3. Kiểm tra xem trong danh sách items có productId này không
        final hasProduct = items.any((item) => item['productId'] == productId);

        if (hasProduct) return true; // Tìm thấy thì cho phép review ngay
      }

      return false; // Không tìm thấy trong bất kỳ đơn hàng nào
    } catch (e) {
      return false;
    }
  }

  // tìm kiếm đơn hàng
  Future<List<Product>> searchProducts(String search) async {
    final snapshot = await _firestore.collection('products').get();
    final allProducts =
        snapshot.docs.map((doc) => Product.fromFirestore(doc)).toList();
    if (search.isEmpty) return allProducts;
    final filteredProducts =
        allProducts.where((product) {
          final names = product.name.values.map((v) => v.toString()).toList();
          return names.any(
            (name) => name.toLowerCase().contains(search.toLowerCase()),
          );
        }).toList();
    return filteredProducts;
  }

  Future<List<Product>> fetchProductsByCategory(String categoryId) async {
    final snapshot =
        await _firestore
            .collection('products')
            .where('categoryId', isEqualTo: categoryId)
            .get();
    return snapshot.docs.map((doc) => Product.fromFirestore(doc)).toList();
  }

  Future<List<Product>> fetchRelatedProducts(
    String categoryId,
    String currentProductId,
  ) async {
    final snapshot =
        await _firestore
            .collection('products')
            .where('categoryId', isEqualTo: categoryId)
            .limit(6) // Giới hạn số lượng truy vấn
            .get();

    final allRelatedProducts =
        snapshot.docs.map((doc) => Product.fromFirestore(doc)).toList();

    // Loại bỏ sản phẩm hiện tại khỏi danh sách và giới hạn 5 sản phẩm
    return allRelatedProducts
        .where((product) => product.id != currentProductId)
        .take(5)
        .toList();
  }

  Future<void> fetchUpdateProduct({
    required String productId,
    required Map<String, dynamic> name,
    required int price,
    required Map<String, dynamic> description,
    required String imageUrl, // Thêm trường ảnh nếu muốn sửa ảnh
    required String categoryId,
  }) async {
    try {
      await _firestore.collection('products').doc(productId).update({
        'name': name,
        'price': price,
        'description': description,
        'imageUrl': imageUrl,
        'categoryId': categoryId,
      });
    } catch (e) {
      throw Expando('Lỗi thêm sản phẩm $e');
    }
  }

  Future<void> fetchDeleteProduct({required String productId}) async {
    try {
      await _firestore.collection('products').doc(productId).delete();
    } catch (e) {
      throw Expando('Lỗi xóa sản phẩm $e');
    }
  }

  Future<void> addProduct({
    required Map<String, dynamic> name,
    required String imageUrl,
    required int price,
    required Map<String, dynamic> description,
    required String categoryId,
  }) async {
    try {
      await _firestore.collection('products').add({
        'name': name,
        'imageUrl': imageUrl,
        'price': price,
        'description': description,
        'categoryId': categoryId,
        'averageRating': 0.0,
        'reviewCount': 0,
        'createdAt': FieldValue.serverTimestamp(),
        'soldCount': 0,
      });
    } catch (e) {
      throw Expando('Lỗi xóa sản phẩm $e');
    }
  }
}
