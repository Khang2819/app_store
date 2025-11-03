import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class BannerModel extends Equatable {
  final String id;
  final String imageUrl;
  final int order;
  final String targetType;
  final String targetId;

  const BannerModel({
    required this.id,
    required this.imageUrl,
    this.order = 0,
    this.targetType = 'none',
    this.targetId = '',
  });

  factory BannerModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return BannerModel(
      id: doc.id,
      imageUrl: data['imageUrl'] ?? '',
      order: (data['order'] ?? 0).toInt(),
      targetType: data['targetType'] ?? 'none',
      targetId: data['targetId'] ?? '',
    );
  }
  @override
  List<Object?> get props => [id, imageUrl, order, targetType, targetId];
}
