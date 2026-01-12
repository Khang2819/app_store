import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_core/repositories/category_repository.dart';
import 'category_admin_event.dart';
import 'category_admin_state.dart';

class CategoryAdminBloc extends Bloc<CategoryAdminEvent, CategoryAdminState> {
  final CategoryRepository
  categoryRepository; // Tái sử dụng Repo đã có hàm fetchCategories

  CategoryAdminBloc({required this.categoryRepository})
    : super(const CategoryAdminState()) {
    on<LoadCategories>(_onLoadCategories);
    on<AddCategory>(_onAddCategory);
    on<DeleteCategory>(_onDeleteCategory);
    on<UpdateCategory>(_onUpdateCategory);
  }

  Future<void> _onLoadCategories(
    LoadCategories event,
    Emitter<CategoryAdminState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    try {
      final categories = await categoryRepository.fetchCategories();
      emit(state.copyWith(isLoading: false, categories: categories));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> _onAddCategory(
    AddCategory event,
    Emitter<CategoryAdminState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    try {
      await categoryRepository.addCategory(
        names: event.names,
        imageUrl: event.imageUrl,
      );
      add(LoadCategories());
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Lỗi thêm danh mục: $e'));
    }
  }

  Future<void> _onDeleteCategory(
    DeleteCategory event,
    Emitter<CategoryAdminState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    try {
      await categoryRepository.fetchDeleteCategory(
        categoryId: event.categoryId,
      );
      add(LoadCategories());
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Lỗi xóa danh mục: $e'));
    }
  }

  Future<void> _onUpdateCategory(
    UpdateCategory event,
    Emitter<CategoryAdminState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    try {
      await categoryRepository.updateCategory(
        categoryId: event.categoryId,
        names: event.names,
        imageUrl: event.imageUrl,
      );
      add(LoadCategories());
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }
}
