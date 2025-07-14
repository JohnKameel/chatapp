import 'package:chat_app/core/database/database_service.dart';
import 'package:chat_app/core/database/failure.dart';
import 'package:chat_app/core/database/supabase_service.dart';
import 'package:chat_app/features/auth/data/model/user_info_model.dart';
import 'package:chat_app/features/home/data/model/room_model.dart';
import 'package:dartz/dartz.dart';

class HomeRepo {
  DatabaseService databaseService;

  HomeRepo(this.databaseService);
  SupabaseService supabaseService = SupabaseService();

  Future<Either<Failure, UserInfoModel>> getUserInfo(userId) async {
    try {
      final row = await supabaseService.fetchCurrentUserData("userInfo", userId);
      final user = UserInfoModel.fromJson(row!);
      return Right(user);
    } catch (e) {
      return Left(DataBaseFailure("Failed to fetch user info: $e"));
    }
  }

  Future<Either<Failure, String>> createRoom(String myId, String anotherId) async {
    final sortId = [myId, anotherId]..sort();
    final idRoom = '${sortId[0]}-${sortId[1]}';

    RoomModel room = RoomModel(
      id: idRoom,
      lastMessage: "",
      unreadMessages: 0,
      members: sortId,
    );

    try {
      await supabaseService.client.from("rooms").upsert(room.toJson(), onConflict: 'id');
      return Right(idRoom);
    }catch (e) {
      return Left(DataBaseFailure("Failed to create room: $e"));
    }
  }

  Stream<List<RoomModel>> getAllRooms() {
    try {
      final myId = supabaseService.currentUserId;
      final stream = supabaseService.client
          .from("rooms")
          .stream(primaryKey: ['id']);

      final allRooms = stream.map((e) {
        return e
            .map((e) => RoomModel.fromJson(e))
            .where((room) => room.members.contains(myId))
            .toList();
      });
      return allRooms;
    } catch (e) {
      throw Exception("Failed to fetch rooms: $e");
  }
  }

  // Stream<List<RoomModel>> getAllRooms(String userId) {
  //   return supabaseService.client
  //       .from("rooms")
  //       .stream(primaryKey: ['id'])
  //       .eq('members', userId)
  //       .order('lastMessage', ascending: false)
  //       .execute()
  //       .map((data) => data.map((e) => RoomModel.fromJson(e)).toList());
  // }
}