import 'package:bloc_app/presentation/bloc/navigation/navigation_event.dart';
import 'package:bloc_app/presentation/screens/home_screen.dart';
import 'package:bloc_app/presentation/screens/person_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/product_repository.dart';
import '../bloc/home/home_bloc.dart';
import '../bloc/navigation/navigation_bloc.dart';
import '../bloc/navigation/navigation_state.dart';

class MainNavScreen extends StatelessWidget {
  const MainNavScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc(ProductRepository()),
      child: BlocBuilder<NavigationBloc, NavigationState>(
        builder: (context, state) {
          final List<Widget> screens = const [
            HomeScreen(),
            Scaffold(body: Center(child: Text("Search Screen"))),
            Scaffold(body: Center(child: Text("Cart Screen"))),
            PersonScreen(),
          ];

          return Scaffold(
            body: IndexedStack(index: state.tabIndex, children: screens),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: state.tabIndex,
              selectedItemColor: Color(0xff2A4ECA),
              unselectedItemColor: Colors.grey,
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
