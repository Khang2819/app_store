import 'package:bloc_app/data/repositories/cart_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/cart_item_model.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository _cartRepository;

  CartBloc(this._cartRepository) : super(CartLoading()) {
    on<LoadCart>(_onLoadCart);
    on<RemoveItemFromCart>(_onRemoveItemFromCart);
    on<UpdateItemQuantity>(_onUpdateItemQuantity);
    on<ClearCart>(_onClearCart);
  }

  Future<void> _onLoadCart(LoadCart event, Emitter<CartState> emit) async {
    emit(CartLoading());
    try {
      final items = await _cartRepository.fetchCart();
      if (items.isEmpty) {
        emit(CartEmpty());
      } else {
        // Tính tổng tiền
        final totalPrice = items.fold(
          0,
          (sum, item) => sum + (item.product.price * item.quantity),
        );
        emit(CartLoaded(items: items, totalPrice: totalPrice));
      }
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  Future<void> _onRemoveItemFromCart(
    RemoveItemFromCart event,
    Emitter<CartState> emit,
  ) async {
    // 1. Chỉ emit nếu state hiện tại là CartLoaded
    if (state is CartLoaded) {
      final currentState = state as CartLoaded;
      try {
        // 2. Cập nhật repository
        await _cartRepository.removeFromCart(event.productId);

        // 3. Cập nhật state thủ công (không gọi LoadCart)
        final newList = List<CartItem>.from(currentState.items)
          ..removeWhere((item) => item.product.id == event.productId);

        if (newList.isEmpty) {
          emit(CartEmpty());
        } else {
          // 4. Tính lại tổng tiền
          final newTotalPrice = newList.fold(
            0,
            (sum, item) => sum + (item.product.price * item.quantity),
          );
          emit(CartLoaded(items: newList, totalPrice: newTotalPrice));
        }
      } catch (e) {
        // (Có thể emit lỗi nếu cần)
      }
    }
  }

  Future<void> _onUpdateItemQuantity(
    UpdateItemQuantity event,
    Emitter<CartState> emit,
  ) async {
    // 1. Chỉ emit nếu state hiện tại là CartLoaded
    final currentState = state;
    if (currentState is CartLoaded) {
      try {
        // 2. Cập nhật repository
        await _cartRepository.updateQuantity(
          event.productId,
          event.newQuantity,
        );

        // 3. Tạo danh sách mới dựa trên thay đổi
        List<CartItem> newList = [];

        // Nếu số lượng mới <= 0, ta xóa item
        if (event.newQuantity <= 0) {
          newList = List<CartItem>.from(currentState.items)
            ..removeWhere((item) => item.product.id == event.productId);
        } else {
          // Nếu không, ta cập nhật số lượng của item đó
          newList =
              currentState.items.map((item) {
                if (item.product.id == event.productId) {
                  return item.copyWith(quantity: event.newQuantity);
                }
                return item;
              }).toList();
        }

        // 4. Kiểm tra xem giỏ hàng có rỗng không
        if (newList.isEmpty) {
          emit(CartEmpty());
        } else {
          // 5. Tính lại tổng tiền và emit CartLoaded mới
          final newTotalPrice = newList.fold(
            0,
            (sum, item) => sum + (item.product.price * item.quantity),
          );
          emit(CartLoaded(items: newList, totalPrice: newTotalPrice));
        }
      } catch (e) {
        // (Có thể emit lỗi nếu cần)
      }
    }
  }

  Future<void> _onClearCart(ClearCart event, Emitter<CartState> emit) async {
    // Chỉ cần phát ra trạng thái giỏ hàng trống
    emit(CartEmpty());
  }
}
