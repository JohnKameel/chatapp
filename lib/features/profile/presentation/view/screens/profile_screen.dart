import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chat_app/core/server_locator/server_locator.dart';
import 'package:chat_app/features/profile/presentation/viewModel/profile_cubit.dart';
import 'package:chat_app/features/auth/data/model/user_info_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    late TextEditingController nameController = TextEditingController();
    late TextEditingController phoneController = TextEditingController();
    final userId = Supabase.instance.client.auth.currentUser?.id;

    return BlocProvider(
      create: (_) {
        final cubit = getIt<ProfileCubit>();
        if (userId != null) {
          cubit.fetchUserInfo();
        }
        return cubit;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Profile'),
        ),
        body: BlocConsumer<ProfileCubit, ProfileState>(
          listener: (context, state) {
            if (state is ProfileFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Error: ${state.message}"),
                  backgroundColor: Colors.red,
                ),
              );
            } else if (state is ProfileUpdated) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Profile updated successfully"),
                  backgroundColor: Colors.green,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is ProfileLoading || state is ProfileUpdating) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ProfileSuccess) {
              final UserInfoModel user = state.user;
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        context.read<ProfileCubit>().uploadImage();
                      },
                      child: Center(
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: user.image_profile != null &&
                                  user.image_profile!.isNotEmpty
                              ? NetworkImage(user.image_profile!)
                              : null,
                          child: user.image_profile == null ||
                                  user.image_profile!.isEmpty
                              ? const Icon(Icons.person, size: 50)
                              : null,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    Text(
                      "Email: ${user.email}",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: nameController..text = user.user_name ?? '',
                      decoration: InputDecoration(
                        labelText: 'Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: phoneController..text = user.phone_num ?? '',
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 60),
                    ElevatedButton(
                      onPressed: () {
                        final name = nameController.text;
                        final phone = phoneController.text;
                        if (name.isNotEmpty && phone.isNotEmpty) {
                          context
                              .read<ProfileCubit>()
                              .updateProfile(name, phone);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Please fill in all fields"),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      child: const Text('Change Profile data'),
                    ),
                  ],
                ),
              );
            } else {
              return Text('No user data available');
            }
          },
        ),
      ),
    );
  }
}
