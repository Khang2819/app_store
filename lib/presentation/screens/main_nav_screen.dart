import 'package:bloc_app/presentation/bloc/navigation/navigation_event.dart';
import 'package:bloc_app/presentation/screens/home_screen.dart';
import 'package:bloc_app/presentation/screens/person_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/navigation/navigation_bloc.dart';
import '../bloc/navigation/navigation_state.dart';

class MainNavScreen extends StatelessWidget {
  const MainNavScreen({super.key});

  final List<Widget> _screen = const [
    HomeScreen(),
    Scaffold(body: Center(child: Text("Search Screen"))),
    Scaffold(body: Center(child: Text("Cart Screen"))),
    PersonScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationBloc, NavigationState>(
      builder: (context, state) {
        return Scaffold(
          body: IndexedStack(index: state.tabIndex, children: _screen),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: state.tabIndex,
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
    );
  }
}
