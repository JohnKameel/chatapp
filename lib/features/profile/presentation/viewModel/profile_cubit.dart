import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../auth/data/model/user_info_model.dart';
import '../../data/repo/profile_repo.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepo profileRepo;
  ProfileCubit(this.profileRepo) : super(ProfileInitial());

  Future<void> fetchUserInfo() async {
    emit(ProfileLoading());
    final result = await profileRepo.getUserInfo();
    result.fold(
      (failure) {
        print("Error fetching user info: ${failure.message}");
        emit(ProfileFailure(failure.message));
        },
      (user) {
        print("User info fetched successfully: ${user.email}");
        emit(ProfileSuccess(user));}
    );
  }

  Future<void> updateProfile(String name, String phone) async {
    emit(ProfileUpdating());
    final result = await profileRepo.updateProfileData(name, phone);
    result.fold(
      (failure) => emit(ProfileFailure(failure.message)),
      (message) async {
        emit(ProfileUpdated(message));
        await fetchUserInfo();
      },
    );
  }

  Future<void> uploadImage() async {
    emit(ProfileUpdating());
    try{
      final file = await profileRepo.pickProfileImage();
      if (file == null) return;

      final url = await profileRepo.uploadProfileImage(file);
      if (url != null) {
        emit(ProfileImageUpdated(url));
        await fetchUserInfo();
      } else {
        emit(ProfileFailure("Failed to upload image"));
      }
    } catch(e){
      emit(ProfileFailure("An error occurred while uploading image: ${e.toString()}"));
    }
  }
}
