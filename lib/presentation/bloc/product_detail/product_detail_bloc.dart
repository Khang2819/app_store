import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/product_repository.dart';
import 'product_detail_event.dart';
import 'product_detail_state.dart';

class ProductDetailBloc extends Bloc<ProductDetailEvent, ProductDetailState> {
  final ProductRepository _productRepository;

  ProductDetailBloc(this._productRepository)
    : super(const ProductDetailState()) {
    on<LoadProductDetail>(_onLoadProductDetail);
    on<QuantityChanged>(_onQuantityChanged);
    on<AddToCart>(_onAddToCart);
    on<AddReview>(_onAddReview);
    on<ResetAddToCartStatus>((event, emit) {
      emit(state.copyWith(addToCartSuccess: false, clearError: true));
    });
  }

  Future<void> _onLoadProductDetail(
    LoadProductDetail event,
    Emitter<ProductDetailState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));
    final user = FirebaseAuth.instance.currentUser;
    try {
      final product = await _productRepository.fetchProduct(event.productId);
      final reviews = await _productRepository.fetchReviews(event.productId);
      bool canReview = false;
      if (user != null) {
        canReview = await _productRepository.checkIfUserPurchasedProduct(
          userId: user.uid,
          productId: event.productId,
        );
      }
      emit(
        state.copyWith(
          isLoading: false,
          product: product,
          reviews: reviews,
          canReview: canReview,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  void _onQuantityChanged(
    QuantityChanged event,
    Emitter<ProductDetailState> emit,
  ) {
    if (event.quantity > 0) {
      emit(state.copyWith(quantity: event.quantity));
    }
  }

  Future<void> _onAddToCart(
    AddToCart event,
    Emitter<ProductDetailState> emit,
  ) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      emit(state.copyWith(error: 'Bạn cần đăng nhập'));
      return;
    }
    emit(state.copyWith(clearError: true, addToCartSuccess: false));
    try {
      await _productRepository.addToCart(
        userId: user.uid,
        productId: event.productId,
        quantity: event.quantity,
      );
      emit(state.copyWith(addToCartSuccess: true));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> _onAddReview(
    AddReview event,
    Emitter<ProductDetailState> emit,
  ) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // Handle not logged in case
      return;
    }
    try {
      await _productRepository.addReview(
        productId: event.productId,
        userId: user.uid,
        userName: user.displayName ?? 'Anonymous',
        rating: event.rating,
        comment: event.comment,
      );
      // Reload reviews
      add(LoadProductDetail(event.productId));
    } catch (e) {
      // Handle error
    }
  }
}
