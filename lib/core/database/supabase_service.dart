import 'package:chat_app/core/database/database_service.dart';
import 'package:gotrue/src/types/user.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService implements DatabaseService {
  @override
  SupabaseClient get client => Supabase.instance.client;

  @override
  Future<User?> signIn(String email, String password) async {
    try {
      final response = await client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return response.user;
    } on AuthException catch (e) {
      print("AuthException: ${e.message}");
      rethrow;
    } catch (e) {
      print("Unexpected error: $e");
      rethrow;
    }
  }

  @override
  Future<User?> signUp(String email, String password) async {
    try {
      final response =
          await client.auth.signUp(email: email, password: password);
      return response.user;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await client.auth.signOut();
    } catch (e) {
      rethrow;
    }
  }

  String? get currentUserId {
    return client.auth.currentUser!.id;
  }

  @override
  Future<void> insert(String table, Map<String, dynamic> data) async {
    try {
      await client.from(table).insert(data);
    } catch(e) {
      rethrow;
    }
  }

  @override
  Future<List<Map<String, dynamic>>> fetchAllDataByFilterNeq(String table, String column, String value) async {
    try {
      final response = await client.from(table).select().neq(column, value);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>?> fetchCurrentUserData(String table, String userId) async {
    try {
      final response = await client.from(table).select().eq('UID', userId).single();
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> update(String table, String column, String value, Map<String, dynamic> data) async {
    try{
      final response = await client.from(table).update(data).eq(column, value);
    }catch (e) {
      rethrow;
    }
  }
}
