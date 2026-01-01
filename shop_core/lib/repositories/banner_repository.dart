import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/banner_model.dart';

class BannerRepository {
  final _firestore = FirebaseFirestore.instance;
  Future<List<BannerModel>> fetchBanners() async {
    final snapshot =
        await _firestore
            .collection('banners')
            .orderBy('order', descending: false)
            .get();
    return snapshot.docs.map((doc) => BannerModel.fromFirestore(doc)).toList();
  }

  Future<void> fetchDeleteBanner({required String bannerId}) async {
    await _firestore.collection('banners').doc(bannerId).delete();
  }

  Future<void> fetchAddBanner({
    required String imageUrl,
    required int order,
    required String targetType,
    required String targetId,
  }) async {
    await _firestore.collection('banners').add({
      'imageUrl': imageUrl,
      'order': order,
      'targetType': targetType,
      'targetId': targetId,
    });
  }

  Future<void> fetchUpdateBanner({
    required String imageUrl,
    required int order,
    required String targetType,
    required String targetId,
  }) async {
    await _firestore.collection('banners').add({
      'imageUrl': imageUrl,
      'order': order,
      'targetType': targetType,
      'targetId': targetId,
    });
  }
}
