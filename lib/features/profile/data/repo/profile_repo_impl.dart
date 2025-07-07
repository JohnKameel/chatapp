import 'dart:io';

import 'package:chat_app/core/database/database_service.dart';
import 'package:chat_app/core/database/failure.dart';
import 'package:chat_app/features/auth/data/model/user_info_model.dart';
import 'package:chat_app/features/profile/data/repo/profile_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileRepoImpl implements ProfileRepo {
  final DatabaseService databaseService;
  final ImagePicker _picker = ImagePicker();
  ProfileRepoImpl(this.databaseService);

  @override
  Future<Either<Failure, UserInfoModel>> getUserInfo() async {
    try {
      final userId = databaseService.client.auth.currentUser?.id;
      if (userId == null) {
        return Left(DataBaseFailure("User ID is null"));
      }
      final data =
          await databaseService.fetchCurrentUserData('userInfo', userId);
      if (data != null) {
        return Right(UserInfoModel.fromJson(data));
      } else {
        return Left(DataBaseFailure('User not found'));
      }
    } catch (e) {
      return Left(
          DataBaseFailure('An unexpected error occurred: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, String>> updateProfileData(
      String name, String phone) async {
    try {
      final userId = databaseService.client.auth.currentUser?.id;
      await databaseService.update("userInfo", "UID", userId, {
        "user_name": name,
        "phone_num": phone,
      });
      return const Right("Profile updated successfully");
    } catch (e) {
      return Left(DataBaseFailure(
          'An error occurred while updating profile: ${e.toString()}'));
    }
  }

  @override
  Future<File?> pickProfileImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      return File(image.path);
    } else {
      return null;
    }
  }

  @override
  Future<String?> uploadProfileImage(File avatarFile) async {
    try {
      final supabase = Supabase.instance.client;
      final String userId = supabase.auth.currentUser!.id;
      // for upload image
      final String fullPath = await supabase.storage.from('images').upload(
            'userProfile/$userId',
            avatarFile,
            fileOptions: FileOptions(upsert: true, cacheControl: '3600'),
          );
      // get public URL
      final String publicUrl =
          supabase.storage.from('images').getPublicUrl('userProfile/$userId');
      // for update
      await supabase.from('userInfo').update({
        'image_profile': publicUrl,
      }).eq('UID', userId);
      return publicUrl;
    } catch (e) {
      print("Error uploading profile image: $e");
      return null;
    }
  }
}
