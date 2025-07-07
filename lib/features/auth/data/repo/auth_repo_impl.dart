import 'package:chat_app/core/database/database_service.dart';
import 'package:chat_app/core/database/failure.dart';
import 'package:chat_app/features/auth/data/model/user_info_model.dart';
import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'auth_repo.dart';

class AuthRepoImpl implements AuthRepo {
  final DatabaseService databaseService;
  AuthRepoImpl(this.databaseService);

  @override
  Future<Either<Failure, User>> login(String email, String password) async {
    try {
      final user = await databaseService.signIn(email, password);
      if (user != null) {
        return Right(user);
      } else {
        return Left(DataBaseFailure('User not found'));
      }
    } on AuthException catch (e) {
      return Left(DataBaseFailure('${e.message}'));
    } catch (e) {
      return Left(DataBaseFailure('An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, User>> register(String email, String password, String userName, String phoneNum,) async {
    try {
      final user = await databaseService.signUp(email, password);
      if (user != null) {
        UserInfoModel userInfo = UserInfoModel(
          UID: user.id,
          email: email,
          user_name: userName,
          phone_num: phoneNum,
          image_profile: '',
        );
        databaseService.insert('userInfo', userInfo.toJson());
        return Right(user);
      } else {
        return Left(DataBaseFailure('User not created'));
      }
    } on AuthException catch (e) {
      return Left(DataBaseFailure('${e.message}'));
    } catch (e) {
      return Left(DataBaseFailure('An unexpected error occurred'));
    }
  }

  @override
  Future<void> logout() async {
    try {
      await databaseService.signOut();
    } on AuthException catch (e) {
      throw DataBaseFailure(e.message);
    } catch (e) {
      throw DataBaseFailure('Unexpected error during logout');
    }
  }
}
