import 'package:chat_app/core/server_locator/server_locator.dart';
import 'package:chat_app/features/auth/presentation/view/screens/login_screen.dart';
import 'package:chat_app/features/contacts/presentation/view/screens/contact_screen.dart';
import 'package:chat_app/features/home/data/model/room_model.dart';
import 'package:chat_app/features/home/presentation/view/screens/chat_screen.dart';
import 'package:chat_app/features/home/presentation/view/screens/home_screen.dart';
import 'package:chat_app/features/profile/presentation/view/screens/profile_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/view/screens/register_screen.dart';
import '../../features/home/presentation/viewModel/messages_cubit.dart';

class RouterApp {
  static const String register = '/register';
  static const String login = '/login';
  static const String home = '/home';
  static const String contact = '/contact';
  static const String profile = '/profile';
  static const String chat = '/chat';

  static GoRouter goRouter = GoRouter(
    initialLocation: register,
    routes: [
      GoRoute(
        path: register,
        builder: (context, state) {
          return const RegisterScreen();
        },
      ),
      GoRoute(
        path: login,
        builder: (context, state) {
          return const LoginScreen();
        },
      ),
      GoRoute(
        path: home,
        builder: (context, state) {
          return const HomeScreen();
        },
      ),
      GoRoute(
        path: contact,
        builder: (context, state) {
          return const ContactScreen();
        },
      ),
      GoRoute(
        path: profile,
        builder: (context, state) {
          return const ProfileScreen();
        },
      ),
      GoRoute(
        path: chat,
        builder: (context, state) {
          final roomModel = state.extra as RoomModel;
          return BlocProvider(
            create: (context) => getIt<MessagesCubit>(),
            child: ChatScreen(roomModel: roomModel),
          );
        },
      ),
    ],
  );
}