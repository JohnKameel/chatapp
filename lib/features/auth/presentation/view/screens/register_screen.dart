import 'package:chat_app/core/routing/router_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/server_locator/server_locator.dart';
import '../../viewModel/auth_cubit.dart';

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
                  SizedBox(
                    height: 320,
                    child: Stack(
                      children: [
                        CustomPaint(
                          size: Size(double.infinity, 320),
                          painter: TopWavePainter(),
                        ),
                        Positioned(
                          top: 78,
                          right: 70,
                          left: 70,
                          child: Image.asset(
                            'assets/images/background.png',
                            color: Colors.white,
                            fit: BoxFit.cover,
                            width: 200,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: [
                        Text(
                          'Register',
                          style: TextStyle(fontSize: 30),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: emailController,
                          decoration: InputDecoration(
                            hintText: 'Email',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: userNameController,
                          decoration: InputDecoration(
                            hintText: 'User Name',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: phoneNumController,
                          decoration: InputDecoration(
                            hintText: 'Phone Number',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          obscureText: true,
                          controller: passwordController,
                          decoration: InputDecoration(
                            hintText: 'Password',
                            border: OutlineInputBorder(),
                          ),
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
                                )),
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

// Custom painter for the wave
class TopWavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint1 = Paint()..color = const Color(0xFFBD9FE9);
    final path1 = Path();
    path1.lineTo(0, size.height - 80);
    path1.quadraticBezierTo(
      size.width * 0.25,
      size.height - 30,
      size.width * 0.5,
      size.height - 60,
    );
    path1.quadraticBezierTo(
      size.width * 0.75,
      size.height - 90,
      size.width,
      size.height - 50,
    );
    path1.lineTo(size.width, 0);
    path1.close();
    canvas.drawPath(path1, paint1);

    final paint2 = Paint()..color = const Color(0xFFAD87E4);
    final path2 = Path();
    path2.lineTo(0, size.height - 100);
    path2.quadraticBezierTo(
      size.width * 0.25,
      size.height - 60,
      size.width * 0.5,
      size.height - 90,
    );
    path2.quadraticBezierTo(
      size.width * 0.75,
      size.height - 120,
      size.width,
      size.height - 80,
    );
    path2.lineTo(size.width, 0);
    path2.close();
    canvas.drawPath(path2, paint2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
