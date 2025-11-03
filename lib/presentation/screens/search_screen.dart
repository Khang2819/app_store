import 'package:bloc_app/presentation/widgets/home_appbar.dart';
import 'package:bloc_app/presentation/widgets/my_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../l10n/app_localizations.dart';
import '../bloc/home/home_bloc.dart';
import '../bloc/search/search_bloc.dart';
import '../bloc/search/search_event.dart';
import '../bloc/search/search_state.dart';
import '../widgets/product_grid.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  void initState() {
    super.initState();
    // 3. Gọi event SearchTextChanged với chuỗi rỗng ngay khi vào màn hình
    //    để tải tất cả sản phẩm
    context.read<SearchBloc>().add(SearchTextChanged(""));
  }

  @override
  Widget build(BuildContext context) {
    final language = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: HomeAppbar(title: language.searchProduct1),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            MySearchBar(
              onChanged:
                  (value) =>
                      context.read<SearchBloc>().add(SearchTextChanged(value)),
            ),
            const SizedBox(height: 30),
            BlocBuilder<SearchBloc, SearchState>(
              builder: (context, searchState) {
                final homeState = context.watch<HomeBloc>().state;
                if (searchState.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xff2A4ECA)),
                  );
                }
                return ProductGrid(
                  products: searchState.results,
                  favorites: homeState.favorites.toSet(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
