import 'package:bloc_app/presentation/bloc/navigation/navigation_event.dart';
import 'package:bloc_app/presentation/bloc/profile/profile_bloc.dart';
import 'package:bloc_app/presentation/screens/cart_screen.dart';
import 'package:bloc_app/presentation/screens/home_screen.dart';
import 'package:bloc_app/presentation/screens/person_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/product_repository.dart';
import '../../data/repositories/user_repository.dart';
import '../bloc/home/home_bloc.dart';
import '../bloc/navigation/navigation_bloc.dart';
import '../bloc/navigation/navigation_state.dart';
import '../bloc/search/search_bloc.dart';
import 'search_screen.dart';

class MainNavScreen extends StatelessWidget {
  const MainNavScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => HomeBloc(ProductRepository())),
        BlocProvider(create: (context) => SearchBloc(ProductRepository())),
        BlocProvider(create: (context) => ProfileBloc(UserRepository())),
      ],
      child: BlocBuilder<NavigationBloc, NavigationState>(
        builder: (context, state) {
          final List<Widget> screens = const [
            HomeScreen(),
            SearchScreen(),
            CartScreen(),
            PersonScreen(),
          ];

          return Scaffold(
            backgroundColor: Color(0xffFFF8F1),
            body: IndexedStack(index: state.tabIndex, children: screens),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: state.tabIndex,
              selectedItemColor: Color(0xffDDB892),
              unselectedItemColor: Color(0xff8B5E3C),
              onTap:
                  (index) => context.read<NavigationBloc>().add(
                    TabChanged(tabIndex: index),
                  ),
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                BottomNavigationBarItem(
                  icon: Icon(Icons.search),
                  label: 'Search',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.shopping_cart),
                  label: 'Cart',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Person',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
