import 'package:chat_app/core/database/supabase_service.dart';
import 'package:chat_app/features/contacts/presentation/viewModel/contacts_cubit.dart';
import 'package:chat_app/features/home/data/repo/home_repo.dart';
import 'package:chat_app/features/home/presentation/viewModel/room_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../auth/data/model/user_info_model.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Add Contacts',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF7B3FD3),
      ),
      body: BlocBuilder<ContactsCubit, ContactsState>(
        builder: (context, state) {
          if (state is ContactsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ContactsFailure) {
            return Center(child: Text(state.errorMessage));
          } else if (state is ContactsSuccess) {
            return ListView.builder(
              itemCount: state.contacts.length,
              itemBuilder: (context, index) {
                // final UserInfoModel user = state.user;
                return Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 8.0,
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.grey[300],
                            backgroundImage:
                                state.contacts[index].image_profile != null &&
                                        state.contacts[index].image_profile!
                                            .isNotEmpty
                                    ? NetworkImage(
                                        state.contacts[index].image_profile!)
                                    : null,
                            child:
                                (state.contacts[index].image_profile == null ||
                                        state.contacts[index].image_profile!
                                            .isEmpty)
                                    ? const Icon(Icons.person,
                                        size: 40, color: Colors.grey)
                                    : null,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  state.contacts[index].user_name,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  state.contacts[index].email,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF7B3FD3),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            onPressed: () {
                              final user = state.contacts[index];
                              context.read<RoomCubit>().createRoom(
                                    SupabaseService()
                                        .client
                                        .auth
                                        .currentUser!
                                        .id,
                                    state.contacts[index].UID,
                                  );
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    '${user.user_name} added successfully!',
                                  ),
                                  duration: const Duration(seconds: 1),
                                ),
                              );
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 4),
                                const Text(
                                  'Add',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                      thickness: 1,
                      color: Color(0xFF7B3FD3),
                    ),
                  ],
                );
              },
            );
          }
          return const Center(child: Text('No contacts found'));
        },
      ),
    );
  }
}
