import 'package:chat_app/core/routing/router_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/server_locator/server_locator.dart';
import '../../viewModel/auth_cubit.dart';
import '../widgets/background_and_image.dart';
import '../widgets/register_text_and_text_fields.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController userNameController = TextEditingController();
    TextEditingController phoneNumController = TextEditingController();
    return BlocProvider(
      create: (context) => getIt<AuthCubit>(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Welcome ${state.email}')),
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
                        RegisterTextAndTextFields(
                          emailController: emailController,
                          passwordController: passwordController,
                          userNameController: userNameController,
                          phoneNumController: phoneNumController,
                        ),
                        const SizedBox(height: 40),
                        state is AuthLoading
                            ? CircularProgressIndicator()
                            : SizedBox(
                                width: 150,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFBD9FE9),
                                  ),
                                  onPressed: () {
                                    context.read<AuthCubit>().registerUser(
                                          emailController.text,
                                          passwordController.text,
                                          userNameController.text,
                                          phoneNumController.text,
                                        );
                                  },
                                  child: Row(
                                    children: [
                                      Icon(Icons.play_arrow_sharp),
                                      const SizedBox(width: 10),
                                      Text(
                                        'Register',
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
                            Text('Already have an account?'),
                            TextButton(
                              onPressed: () {
                                context.push(RouterApp.login);
                              },
                              child: Text(
                                'Login',
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
