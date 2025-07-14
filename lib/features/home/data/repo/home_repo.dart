import 'package:chat_app/core/database/database_service.dart';
import 'package:chat_app/core/database/failure.dart';
import 'package:chat_app/core/database/supabase_service.dart';
import 'package:chat_app/features/auth/data/model/user_info_model.dart';
import 'package:chat_app/features/home/data/model/message_model.dart';
import 'package:chat_app/features/home/data/model/room_model.dart';
import 'package:dartz/dartz.dart';

class HomeRepo {
  DatabaseService databaseService;

  HomeRepo(this.databaseService);
  SupabaseService supabaseService = SupabaseService();

  Future<Either<Failure, UserInfoModel>> getUserInfo(userId) async {
    try {
      final row =
          await supabaseService.fetchCurrentUserData("userInfo", userId);
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
      await supabaseService.client
          .from("rooms")
          .upsert(room.toJson(), onConflict: 'id');
      return Right(idRoom);
    } catch (e) {
      return Left(DataBaseFailure("Failed to create room: $e"));
    }
  }

  Stream<List<RoomModel>> getAllRooms() {
    try {
      final myId = supabaseService.currentUserId;
      final stream =
          supabaseService.client.from("rooms").stream(primaryKey: ['id']);

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


  Future<void> sendMessage(roomId, content) async {
    final myId = supabaseService.client.auth.currentUser!.id;
    MessageModel message = MessageModel(
      roomId: roomId,
      senderId: myId,
      content: content,
      createdAt: DateTime.now(),
      seenBy: [myId],
    );

    try {
      await supabaseService.insert("messages", message.toJson());
      print("Message sent successfully");
      await supabaseService.update(
          "rooms", "id", roomId, {"lastMessage": content});
    } catch (e) {
      throw Exception("Failed to send message: $e");
    }
  }

  // for unread messages count
  Future<int> getUnreadMessagesCount(String roomId) async {
    final myId = supabaseService.client.auth.currentUser!.id;

    final messages = await supabaseService.client
        .from('messages')
        .select('id, seenBy')
        .eq('roomId', roomId)
        .neq('senderId', myId)
        .then((value) => List<Map<String, dynamic>>.from(value));

    int unreadCount = 0;
    for (var msg in messages) {
      final seenBy = List<String>.from(msg['seenBy'] ?? []);
      if (!seenBy.contains(myId)) {
        unreadCount++;
      }
    }

    return unreadCount;
  }


  Future<void> markMessagesAsSeen(String roomId) async {
    final myId = supabaseService.client.auth.currentUser!.id;

    final messages = await supabaseService.client
        .from('messages')
        .select('id, seenBy')
        .eq('roomId', roomId)
        .neq('senderId', myId)
        .then((value) => List<Map<String, dynamic>>.from(value));

    for (var msg in messages) {
      final seenBy = List<String>.from(msg['seenBy'] ?? []);

      if (!seenBy.contains(myId)) {
        seenBy.add(myId);

        await supabaseService.client
            .from('messages')
            .update({'seenBy': seenBy})
            .eq('id', msg['id']);
      }
    }
  }



  Stream<List<MessageModel>> getAllMessages(roomId) {
    try {
      final stream = supabaseService.client
          .from("messages")
          .stream(primaryKey: ['id'])
          .eq('roomId', roomId)
          .order('createdAt', ascending: true);

      return stream
          .map((data) => data.map((e) => MessageModel.fromJson(e)).toList());
    } catch (e) {
      throw Exception("Failed to fetch messages: $e");
    }
  }
}
