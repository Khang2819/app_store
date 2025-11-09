import 'package:bloc_app/l10n/app_localizations.dart';
import 'package:bloc_app/presentation/widgets/my_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../core/snackbar_utils.dart';
import '../../data/models/banner_model.dart';
import '../../data/repositories/product_repository.dart';
import '../bloc/home/home_bloc.dart';
import '../bloc/home/home_event.dart';
import '../bloc/home/home_state.dart';
import '../bloc/navigation/navigation_bloc.dart';
import '../bloc/navigation/navigation_event.dart';
import '../widgets/banner_carousel.dart';
import '../widgets/category_grid.dart';
import '../widgets/home_appbar.dart';
import '../widgets/product_grid.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ProductRepository _productRepository = ProductRepository();
  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(LoadHomeData());
  }

  void _handleBannerTap(BannerModel banner) async {
    if (banner.targetType == 'product') {
      try {
        final product = await _productRepository.fetchProduct(banner.targetId);
        if (mounted) {
          context.push('/product', extra: product);
        }
      } catch (e) {
        if (mounted) {
          final language = AppLocalizations.of(context)!;
          SnackbarUtils.showError(
            context,
            'Lỗi tải chi tiết sản phẩm: ${e.toString().split(':').last.trim()}',
            language,
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final language = AppLocalizations.of(context)!;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Color(0xffFFF8F0),
        appBar: HomeAppbar(),
        body: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state.isLoading && state.products.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(color: Color(0xff2A4ECA)),
              );
            }

            if (state.error != null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Có lỗi xảy ra',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.error!,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        context.read<HomeBloc>().add(LoadHomeData());
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Thử lại'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff2A4ECA),
                      ),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<HomeBloc>().add(LoadHomeData());
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {
                        context.read<NavigationBloc>().add(
                          const TabChanged(tabIndex: 1),
                        );
                      },
                      child: AbsorbPointer(
                        // AbsorbPointer ngăn người dùng tương tác (nhấn vào)
                        // TextField thật sự ở bên trong MySearchBar
                        child: const MySearchBar(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    BannerCarousel(
                      banners: state.banners,
                      onBannerTap: _handleBannerTap,
                    ),
                    const SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Text(
                        language.category,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    CategoryGrid(
                      categories: state.categories,
                      onCategoryTap: (category) {
                        context.push('/category-products', extra: category);
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            language.product,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextButton(
                            onPressed: () => context.push('/all-products'),
                            child: Text(
                              language.seeAll,
                              style: TextStyle(color: Color(0xff2A4ECA)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    ProductGrid(
                      products: state.products,
                      favorites: state.favorites.toSet(),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
