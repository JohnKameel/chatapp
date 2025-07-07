import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/routing/router_app.dart';
import '../../../../../core/server_locator/server_locator.dart';
import '../../../../auth/presentation/viewModel/auth_cubit.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AuthCubit>(),
      child: Builder(
        builder: (context) => BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthLogoutSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Logged out successfully')),
              );
              context.go(RouterApp.login);
            }
          },
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Home'),
              centerTitle: true,
              actions: [
                IconButton(
                  onPressed: () {
                    context.push(RouterApp.profile);
                  },
                  icon: Icon(Icons.person_rounded),
                ),
                IconButton(
                  onPressed: () {
                    context.read<AuthCubit>().logoutUser();
                  },
                  icon: Icon(Icons.logout),
                ),
              ],
            ),
            body: Center(
              child: Text(
                'Welcome to the Home Screen',
                style: TextStyle(fontSize: 24),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                context.push(RouterApp.contact);
              },
              child: Icon(Icons.contacts),
            ),
          ),
        ),
      ),
    );
  }
}
