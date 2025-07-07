import 'dart:io';

import 'package:dartz/dartz.dart';

import '../../../../core/database/failure.dart';
import '../../../auth/data/model/user_info_model.dart';

abstract class ProfileRepo {
  Future<Either<Failure, UserInfoModel>> getUserInfo();
  Future<Either<Failure, String>> updateProfileData(String name, String phone);

  // profile image upload
  Future<File?> pickProfileImage();
  Future<String?> uploadProfileImage(File avatarFile);
}