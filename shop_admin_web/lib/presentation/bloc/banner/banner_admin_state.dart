import 'package:equatable/equatable.dart';
import 'package:shop_core/shop_core.dart';

class BannerAdminState extends Equatable {
  final bool isLoading;
  final String? errorMessage;
  final List<BannerModel> banner;
  final bool isActionLoading;
  const BannerAdminState({
    this.isLoading = true,
    this.errorMessage,
    this.banner = const [],
    this.isActionLoading = false,
  });
  BannerAdminState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<BannerModel>? banner,
    bool? isActionLoading,
  }) {
    return BannerAdminState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      banner: banner ?? this.banner,
      isActionLoading: isActionLoading ?? this.isActionLoading,
    );
  }

  @override
  List<Object?> get props => [isLoading, errorMessage, banner, isActionLoading];
}
