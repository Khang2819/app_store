import 'package:shop_core/core/localization_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:shop_core/shop_core.dart';
import '../bloc/category_products/category_products_bloc.dart';
import '../bloc/category_products/category_products_event.dart';
import '../bloc/category_products/category_products_state.dart';
import '../bloc/home/home_bloc.dart';
import '../widgets/home_appbar.dart';
import '../widgets/product_grid.dart';

class CategoryProductsScreen extends StatefulWidget {
  final Category category;
  const CategoryProductsScreen({super.key, required this.category});

  @override
  State<CategoryProductsScreen> createState() => _CategoryProductsScreenState();
}

class _CategoryProductsScreenState extends State<CategoryProductsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CategoryProductsBloc>().add(
      LoadCategoryProduct(widget.category.id),
    );
  }

  @override
  Widget build(BuildContext context) {
    final categoryName = widget.category.localizedCategoryName(context);
    return Scaffold(
      appBar: HomeAppbar(title: categoryName, showBackButton: true),
      body: BlocBuilder<CategoryProductsBloc, CategoryProductsState>(
        builder: (context, state) {
          final favoriteIds = context.watch<HomeBloc>().state.favorites.toSet();

          if (state.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xff2A4ECA)),
            );
          }

          if (state.error != null) {
            return Center(
              child: Text(
                'Lỗi khi tải sản phẩm: ${state.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          if (state.products.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.store_mall_directory_outlined,
                    size: 80,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Không tìm thấy sản phẩm nào trong danh mục $categoryName',
                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: ProductGrid(
                products: state.products,
                favorites: favoriteIds,
              ),
            ),
          );
        },
      ),
    );
  }
}
