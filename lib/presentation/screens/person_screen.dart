import 'package:bloc_app/presentation/bloc/auth/auth_bloc.dart';
import 'package:bloc_app/presentation/bloc/auth/auth_even.dart';
import 'package:bloc_app/presentation/bloc/navigation/navigation_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/auth/auth_state.dart';
import '../bloc/navigation/navigation_bloc.dart';

class PersonScreen extends StatelessWidget {
  const PersonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.isSuccess) {
          context.read<NavigationBloc>().add(NavigationReset());
          context.go('/login');
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Persons'),
          actions: [
            IconButton(
              onPressed: () async {
                context.read<AuthBloc>().add(Logout());
              },
              icon: Icon(Icons.logout),
            ),
          ],
        ),
      ),
    );
  }
}
