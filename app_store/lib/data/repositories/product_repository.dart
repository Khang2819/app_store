import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/banner_model.dart';
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
      final ordersSnapshot =
          await _firestore
              .collection('users')
              .doc(userId)
              .collection('orders')
              .where('productId', isEqualTo: productId)
              // Đảm bảo chỉ tính các đơn hàng đã thành công
              .where('status', whereIn: ['paid', 'completed', 'delivered'])
              .limit(1)
              .get();

      // Nếu tìm thấy bất kỳ đơn hàng nào khớp, trả về true
      return ordersSnapshot.docs.isNotEmpty;
    } catch (e) {
      // Mặc định là không cho phép nếu có lỗi
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

  // này là baner quản cáo nha
  // lấy từ firebase

  Future<List<BannerModel>> fetchBanners() async {
    final snapshot =
        await _firestore
            .collection('banners')
            .orderBy('order', descending: false)
            .get();
    return snapshot.docs.map((doc) => BannerModel.fromFirestore(doc)).toList();
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
}
