import 'package:shop_core/l10n/app_localizations.dart';
import 'package:bloc_app/presentation/bloc/favorites/favorites_bloc.dart';
import 'package:bloc_app/presentation/bloc/favorites/favorites_event.dart';
import 'package:bloc_app/presentation/bloc/favorites/favorites_state.dart';
import 'package:bloc_app/presentation/bloc/home/home_bloc.dart';
import 'package:bloc_app/presentation/widgets/home_appbar.dart';
import 'package:bloc_app/presentation/widgets/product_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/home/home_state.dart';
import '../widgets/my_search_bar.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final language = AppLocalizations.of(context)!;

    // Lấy danh sách ID sản phẩm yêu thích từ HomeBloc
    final favoriteIds = context.select((HomeBloc bloc) => bloc.state.favorites);

    // Kích hoạt LoadFavoriteProducts ngay khi widget được build (lần đầu tiên)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (favoriteIds.isNotEmpty) {
        context.read<FavoritesBloc>().add(LoadFavoriteProducts(favoriteIds));
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xffFFF8F0),
      appBar: HomeAppbar(
        title: language.favorites, // Dùng l10n key mới
        showBackButton: true,
      ),
      // BlocListener để lắng nghe thay đổi của HomeBloc (khi favorite được thêm/xóa)
      body: BlocListener<HomeBloc, HomeState>(
        listenWhen: (p, c) => p.favorites != c.favorites,
        listener: (context, homeState) {
          // Tải lại danh sách sản phẩm chi tiết khi list ID thay đổi
          context.read<FavoritesBloc>().add(
            LoadFavoriteProducts(homeState.favorites),
          );
        },
        child: BlocBuilder<FavoritesBloc, FavoritesState>(
          builder: (context, state) {
            // Hiển thị trạng thái rỗng
            if (context.watch<HomeBloc>().state.favorites.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.favorite_border,
                      size: 80,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      language.favorites_empty,
                      style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                    ),
                  ],
                ),
              );
            }

            // Hiển thị Loading
            if (state.isLoading) {
              return const Center(
                child: CircularProgressIndicator(color: Color(0xff2A4ECA)),
              );
            }

            // Hiển thị Lỗi
            if (state.error != null) {
              return Center(
                child: Text(
                  'Lỗi khi tải sản phẩm yêu thích: ${state.error}',
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }

            // Hiển thị danh sách sản phẩm
            return SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  MySearchBar(
                    onChanged: (query) {
                      context.read<FavoritesBloc>().add(SearchFavorites(query));
                    },
                  ),
                  const SizedBox(height: 30),
                  ProductGrid(
                    products: state.favoriteProducts,
                    // Truyền favorites từ HomeState để ProductCard hiển thị icon đúng
                    favorites:
                        context.watch<HomeBloc>().state.favorites.toSet(),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
