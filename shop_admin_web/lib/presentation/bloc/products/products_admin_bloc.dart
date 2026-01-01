import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_core/shop_core.dart';

import 'products_admin_event.dart';
import 'products_admin_state.dart';

class ProductsAdminBloc extends Bloc<ProductsAdminEvent, ProductsAdminState> {
  final ProductRepository productRepository;
  ProductsAdminBloc({required this.productRepository})
    : super(const ProductsAdminState()) {
    on<LoadProducts>(_onLoadProducts);
    on<UpdateProducts>(_onUpdateProducts);
    on<DeleteProducts>(_onDeleteProducts);
    on<AddProduct>(_onAddProduct);
  }

  Future<void> _onLoadProducts(
    LoadProducts event,
    Emitter<ProductsAdminState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final products = await productRepository.fetchProducts();
      emit(
        state.copyWith(
          isLoading: false,
          products: products,
          errorMessage: null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Không thể tải danh sách sản phẩm: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onUpdateProducts(
    UpdateProducts event,
    Emitter<ProductsAdminState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      await productRepository.fetchUpdateProdust(
        productId: event.productId,
        name: event.name,
        price: event.price,
        description: event.description,
      );
      final updateProduct = await productRepository.fetchProducts();
      emit(
        state.copyWith(
          isLoading: false,
          products: updateProduct,
          errorMessage: null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Không thể tải danh sách sản phẩm: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onDeleteProducts(
    DeleteProducts event,
    Emitter<ProductsAdminState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      await productRepository.fetchDeleteProduct(productId: event.productId);
      final deleteProduct = await productRepository.fetchProducts();
      emit(
        state.copyWith(
          isLoading: false,
          products: deleteProduct,
          errorMessage: null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Không xóa được sản phẩm ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onAddProduct(
    AddProduct event,
    Emitter<ProductsAdminState> emit,
  ) async {
    emit(state.copyWith(isActionLoading: true, errorMessage: null));
    try {
      await productRepository.addProduct(
        name: event.names,
        imageUrl: event.imageUrl,
        price: event.price,
        description: event.descriptions,
        categoryId: event.categoryId,
      );

      // Tải lại danh sách sau khi thêm thành công
      final updatedProducts = await productRepository.fetchProducts();

      emit(
        state.copyWith(
          isActionLoading: false,
          products: updatedProducts,
          errorMessage: null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isActionLoading: false,
          errorMessage: 'Lỗi không xác định khi thêm sản phẩm: ${e.toString()}',
        ),
      );
    }
  }
}
