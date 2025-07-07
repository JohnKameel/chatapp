import 'package:chat_app/core/database/failure.dart';
import 'package:chat_app/features/auth/data/model/user_info_model.dart';
import 'package:dartz/dartz.dart';

abstract class ContactRepo {
  Future<Either<Failure, List<UserInfoModel>>> getAllContacts();
}