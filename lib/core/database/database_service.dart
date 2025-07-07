import 'package:supabase_flutter/supabase_flutter.dart';

abstract class DatabaseService {
  dynamic get client;

  Future<User?> signUp(String email, String password);
  Future<User?> signIn(String email, String password);
  Future<void> signOut();

  Future<void> insert(String table, Map<String, dynamic> data);

  Future<List<Map<String, dynamic>>> fetchAllDataByFilterNeq(String table, String column, String value);

  // fetch current user data
  Future<Map<String, dynamic>?> fetchCurrentUserData(String table, String userId);

  Future<void> update(String table, String column, String value, Map<String, dynamic> data);
}
