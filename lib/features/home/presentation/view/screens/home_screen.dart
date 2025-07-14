import 'package:chat_app/features/home/presentation/viewModel/room_cubit.dart';
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
            body: BlocBuilder<RoomCubit, RoomState>(
              builder: (context, state) {
                if(state is GetAllRoomLoading) {
                  return Center(child: CircularProgressIndicator(),);
                }
                if(state is GetAllRoomFailure) {
                  return Center(child: Text(state.error),);
                }
                if (state is GetAllRoomSuccess) {
                  context.read<RoomCubit>().updateUnreadCounts(state.rooms);
                  final rooms = state.rooms;
                  if (rooms.isEmpty) {
                    return Center(child: Text('No rooms available'));
                  }
                  return ListView.builder(
                    itemCount: rooms.length,
                    itemBuilder: (context, index) {
                      final room = rooms[index];
                      return ListTile(
                        onTap: () {
                          context.push(RouterApp.chat, extra: room);
                        },
                        title: Text(room.otherUserInfo?.user_name ?? 'Unknown User'),
                        subtitle: Text(state.rooms[index].lastMessage),
                        leading: CircleAvatar(
                          radius: 25,
                          backgroundImage: NetworkImage(room.otherUserInfo?.image_profile ?? ''),
                        ),
                        trailing: room.unreadMessages > 0
                            ? CircleAvatar(
                          radius: 10,
                          backgroundColor: Colors.red,
                          child: Text(
                            room.unreadMessages.toString(),
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        )
                            : null,
                      );
                    },
                  );
                }
                return SizedBox.shrink();
              },
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
