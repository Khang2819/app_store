import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/product_model.dart';
import '../bloc/home/home_bloc.dart';
import '../bloc/home/home_event.dart';
import 'product_card.dart';

class ProductGrid extends StatelessWidget {
  final List<Product> products;
  final Set<String> favorites;

  const ProductGrid({
    super.key,
    required this.products,
    required this.favorites,
  });

  @override
  Widget build(BuildContext context) {
    // if (products.isEmpty) {
    //   return const Center(
    //     child: Padding(
    //       padding: EdgeInsets.all(32.0),
    //       child: Text(
    //         'Chưa có sản phẩm nào',
    //         style: TextStyle(color: Colors.grey),
    //       ),
    //     ),
    //   );
    // }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        final isFavorite = favorites.contains(product.id);

        return ProductCard(
          product: product,
          isFavorite: isFavorite,
          onFavoriteToggle: () {
            context.read<HomeBloc>().add(ToggleFavorite(product.id));
          },
          onTap: () {
            context.push('/product', extra: product);
          },
        );
      },
    );
  }
}
