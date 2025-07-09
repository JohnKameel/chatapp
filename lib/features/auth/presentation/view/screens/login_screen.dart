import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/routing/router_app.dart';
import '../../../../../core/server_locator/server_locator.dart';
import '../../viewModel/auth_cubit.dart';
import '../widgets/background_and_image.dart';
import '../widgets/login_text_and_text_fields.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    return BlocProvider(
      create: (context) => getIt<AuthCubit>(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Welcome back ${state.email}')),
              );
              context.go(RouterApp.home);
            }
            if (state is AuthFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  BackgroundAndImage(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: [
                        LoginTextAndTextFields(
                          emailController: emailController,
                          passwordController: passwordController,
                        ),
                        const SizedBox(height: 40),
                        state is AuthLoading
                            ? CircularProgressIndicator()
                            : SizedBox(
                                width: 140,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFBD9FE9),
                                  ),
                                  onPressed: () {
                                    context.read<AuthCubit>().loginUser(
                                          emailController.text,
                                          passwordController.text,
                                        );
                                  },
                                  child: Row(
                                    children: [
                                      Icon(Icons.play_arrow_sharp),
                                      const SizedBox(width: 10),
                                      Text(
                                        'Login',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                        const SizedBox(height: 60),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Don\'t have an account? ',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                context.push(RouterApp.register);
                              },
                              child: Text(
                                'Register',
                                style: TextStyle(
                                  color: const Color(0xFFBD9FE9),
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
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
