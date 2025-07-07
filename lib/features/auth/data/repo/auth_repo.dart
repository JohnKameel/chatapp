import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/database/failure.dart';

abstract class AuthRepo {

  Future<Either<Failure, User>> login(String email, String password);
  Future<Either<Failure, User>> register(String email, String password, String userName, String phoneNum,);
  Future<void> logout();
}