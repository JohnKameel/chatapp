import 'package:chat_app/core/database/database_service.dart';
import 'package:chat_app/core/database/failure.dart';
import 'package:chat_app/core/database/supabase_service.dart';

import 'package:chat_app/features/auth/data/model/user_info_model.dart';

import 'package:dartz/dartz.dart';

import 'contact_repo.dart';

class ContactRepoImpl implements ContactRepo {
  DatabaseService databaseService;
  ContactRepoImpl(this.databaseService);
  @override
  Future<Either<Failure, List<UserInfoModel>>> getAllContacts() async {
    try {
      final userid = SupabaseService().client.auth.currentUser!.id;
      final rows = await databaseService.fetchAllDataByFilterNeq('userInfo', 'UID', userid);

      final users = rows.map((e) => UserInfoModel.fromJson(e)).toList();
      print('Fetched users: $users');

      return Right(users);
    } catch (e) {
      if (e is DataBaseFailure) {
        return Left(e);
      } else {
        return Left(DataBaseFailure('An unexpected error occurred'));
      }
    }
  }

}