import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_core/shop_core.dart';

import 'banner_admin_event.dart';
import 'banner_admin_state.dart';

class BannerAdminBloc extends Bloc<BannerAdminEvent, BannerAdminState> {
  final BannerRepository bannerRepository;
  BannerAdminBloc({required this.bannerRepository})
    : super(const BannerAdminState()) {
    on<LoadBanner>(_onLoadBanner);
    on<AddBanner>(_onAddBanner);
    on<DeleteBanner>(_onDeleteBanner);
  }

  Future<void> _onLoadBanner(
    LoadBanner event,
    Emitter<BannerAdminState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final banner = await bannerRepository.fetchBanners();
      emit(
        state.copyWith(isLoading: false, banner: banner, errorMessage: null),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Không thể tải danh sách banner: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onAddBanner(
    AddBanner event,
    Emitter<BannerAdminState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      await bannerRepository.fetchAddBanner(
        imageUrl: event.imageUrl,
        order: event.order,
        targetType: event.targetType,
        targetId: event.targetId,
      );
      final banner = await bannerRepository.fetchBanners();
      emit(state.copyWith(isLoading: true, banner: banner, errorMessage: null));
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Không thể tải danh sách banner: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onDeleteBanner(
    DeleteBanner event,
    Emitter<BannerAdminState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      await bannerRepository.fetchDeleteBanner(bannerId: event.bannerId);
      final banner = await bannerRepository.fetchBanners();
      emit(
        state.copyWith(isLoading: false, banner: banner, errorMessage: null),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Không thể tải danh sách banner: ${e.toString()}',
        ),
      );
    }
  }
}
