import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_core/shop_core.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final ProductRepository _repository;

  HomeBloc(this._repository) : super(HomeState()) {
    on<LoadHomeData>(_onLoadHomeData);
    on<ToggleFavorite>(_onToggleFavorite);
  }

  Future<void> _onLoadHomeData(
    LoadHomeData event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final user = FirebaseAuth.instance.currentUser;
    try {
      final products = await _repository.fetchProducts();
      final categories = await _repository.fetchCategories();
      final banners = await _repository.fetchBanners();
      List<String> favorites = [];
      if (user != null) {
        favorites = await _repository.fetchFavorites(user.uid);
      }
      emit(
        state.copyWith(
          isLoading: false,
          products: products,
          categories: categories,
          banners: banners,
          favorites: favorites,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onToggleFavorite(
    ToggleFavorite event,
    Emitter<HomeState> emit,
  ) async {
    final user = FirebaseAuth.instance.currentUser;
    // Cập nhật local state ngay lập tức (optimistic update)
    final currentFavs = List<String>.from(state.favorites);
    final isAdding = !currentFavs.contains(event.productId);

    if (isAdding) {
      currentFavs.add(event.productId);
    } else {
      currentFavs.remove(event.productId);
    }
    emit(state.copyWith(favorites: currentFavs));

    // Nếu người dùng chưa đăng nhập, chỉ cập nhật local state và dừng lại
    if (user == null) {
      // Trong ứng dụng thực tế, nên hiển thị thông báo yêu cầu đăng nhập
      return;
    }

    // Gọi Repository để lưu lên Firebase
    try {
      await _repository.toggleFavorite(
        userId: user.uid,
        productId: event.productId,
        isAdding: isAdding,
      );
      // Nếu thành công, không làm gì vì state đã được cập nhật
    } catch (e) {
      // Nếu có lỗi, rollback (hoàn nguyên) lại local state
      final revertedFavs = List<String>.from(state.favorites);
      if (isAdding) {
        revertedFavs.remove(event.productId);
      } else {
        revertedFavs.add(event.productId);
      }
      // Revert lại state và hiển thị lỗi
      emit(state.copyWith(favorites: revertedFavs, error: e.toString()));
    }
  }
}
