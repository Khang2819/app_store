import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_core/shop_core.dart';
import 'category_admin_event.dart';
import 'category_admin_state.dart';

class CategoryAdminBloc extends Bloc<CategoryAdminEvent, CategoryAdminState> {
  final ProductRepository
  productRepository; // Tái sử dụng Repo đã có hàm fetchCategories
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CategoryAdminBloc({required this.productRepository})
    : super(const CategoryAdminState()) {
    on<LoadCategories>(_onLoadCategories);
    on<AddCategory>(_onAddCategory);
    on<DeleteCategory>(_onDeleteCategory);
  }

  Future<void> _onLoadCategories(
    LoadCategories event,
    Emitter<CategoryAdminState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    try {
      final categories = await productRepository.fetchCategories();
      emit(state.copyWith(isLoading: false, categories: categories));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> _onAddCategory(
    AddCategory event,
    Emitter<CategoryAdminState> emit,
  ) async {
    try {
      await _firestore.collection('categories').add({
        'name': event.names,
        'createdAt': FieldValue.serverTimestamp(),
      });
      add(LoadCategories()); // Tải lại danh sách sau khi thêm thành công
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Lỗi thêm danh mục: $e'));
    }
  }

  Future<void> _onDeleteCategory(
    DeleteCategory event,
    Emitter<CategoryAdminState> emit,
  ) async {
    try {
      await _firestore.collection('categories').doc(event.categoryId).delete();
      add(LoadCategories()); // Tải lại danh sách sau khi xóa thành công
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Lỗi xóa danh mục: $e'));
    }
  }
}
