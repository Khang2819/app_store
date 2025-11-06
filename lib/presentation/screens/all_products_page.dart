import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/see_all_screen/see_all_screen_bloc.dart';
import '../bloc/see_all_screen/see_all_screen_event.dart';
import '../bloc/see_all_screen/see_all_screen_state.dart';
import '../widgets/home_appbar.dart';
import '../widgets/my_search_bar.dart';
import '../widgets/product_grid.dart';

class AllProductsPage extends StatefulWidget {
  const AllProductsPage({super.key});
  @override
  State<AllProductsPage> createState() => _AllProductsPageState();
}

class _AllProductsPageState extends State<AllProductsPage> {
  @override
  void initState() {
    context.read<SeeAllScreenBloc>().add(LoadSeeAll());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFFF8F1),
      appBar: HomeAppbar(title: 'Tất cả sản phẩm', showBackButton: true),
      body: BlocBuilder<SeeAllScreenBloc, SeeAllScreenState>(
        builder: (context, state) {
          if (state.isLoading && state.allProducts.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xff2A4ECA)),
            );
          }
          return Column(
            children: [
              const SizedBox(height: 20),
              MySearchBar(
                onChanged: (query) {
                  context.read<SeeAllScreenBloc>().add(SearchSeeAll(query));
                },
              ),
              const SizedBox(height: 20),
              Expanded(
                child: DefaultTabController(
                  length: 3,
                  child: Column(
                    children: [
                      TabBar(
                        labelColor: Color(0xff8B5E3C),
                        unselectedLabelColor: Color(0xffDDB892),
                        indicatorColor: Color(0xff8B5E3C),
                        tabs: [
                          Tab(text: 'Tất cả'),
                          Tab(text: 'Mới nhất'),
                          Tab(text: 'Bán chạy nhất'),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: TabBarView(
                          children: [
                            SingleChildScrollView(
                              child: ProductGrid(
                                products: state.filteredAllProducts,
                                favorites: state.favorites.toSet(),
                              ),
                            ),
                            SingleChildScrollView(
                              child: ProductGrid(
                                products: state.filteredLatestProducts,
                                favorites: state.favorites.toSet(),
                              ),
                            ),
                            SingleChildScrollView(
                              child: ProductGrid(
                                products: state.filteredBestSellingProducts,
                                favorites: state.favorites.toSet(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
