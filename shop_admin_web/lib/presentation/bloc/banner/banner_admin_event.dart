import 'package:equatable/equatable.dart';

abstract class BannerAdminEvent extends Equatable {
  const BannerAdminEvent();
  @override
  List<Object> get props => [];
}

class LoadBanner extends BannerAdminEvent {}

class AddBanner extends BannerAdminEvent {
  final String imageUrl;
  final int order;
  final String targetType;
  final String targetId;
  const AddBanner({
    required this.imageUrl,
    required this.order,
    required this.targetId,
    required this.targetType,
  });
  @override
  List<Object> get props => [imageUrl, order, targetId, targetType];
}

class PauseBanner extends BannerAdminEvent {}

class DeleteBanner extends BannerAdminEvent {
  final String bannerId;
  const DeleteBanner({required this.bannerId});
  @override
  List<Object> get props => [bannerId];
}

class UpdateBanner extends BannerAdminEvent {
  final String bannerId;
  final String imageUrl;
  final int order;
  final String targetType;
  final String targetId;
  const UpdateBanner({
    required this.bannerId,
    required this.imageUrl,
    required this.order,
    required this.targetId,
    required this.targetType,
  });
  @override
  List<Object> get props => [bannerId, imageUrl, order, targetType, targetId];
}
