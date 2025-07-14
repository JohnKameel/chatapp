import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chat_app/features/home/data/repo/home_repo.dart';
import 'package:meta/meta.dart';

import '../../data/model/room_model.dart';

part 'room_state.dart';

class RoomCubit extends Cubit<RoomState> {
  HomeRepo homeRepo;
  RoomCubit(this.homeRepo) : super(RoomInitial());

  final List<RoomModel> _cachedRooms = [];

  createRoom(myId, anotherId) async {
    emit(CreateRoomLoading());

    final result = await homeRepo.createRoom(myId, anotherId);
    result.fold((failure) {
      emit(CreateRoomFailure(failure.message));
    }, (message) {
      emit(CreateRoomSuccess(message));
    });
  }

  StreamSubscription<List<RoomModel>>? roomSubscription;

  void getAllRooms() {
    emit(GetAllRoomLoading());
    try {
      roomSubscription = homeRepo.getAllRooms().listen((rooms) async {
        final myId = homeRepo.supabaseService.currentUserId;
        List<RoomModel> roomWithUsers = [];

        for (var room in rooms) {
          final anotherId = room.members.firstWhere((id) => id != myId);

          final user = await homeRepo.getUserInfo(anotherId);

          final unreadCount = await homeRepo.getUnreadMessagesCount(room.id);

          user.fold((failure) {
            emit(GetAllRoomFailure(failure.message));
          }, (user) {
            room.otherUserInfo = user;
            room.unreadMessages = unreadCount;
            roomWithUsers.add(room);
          });
        }
        _cachedRooms
          ..clear()
          ..addAll(roomWithUsers);
        emit(GetAllRoomSuccess(List.from(_cachedRooms)));
      });
    } catch (e) {
      emit(GetAllRoomFailure(e.toString()));
    }
  }

  Future<void> updateUnreadCounts(String roomId) async {
    try {
      final count = await homeRepo.getUnreadMessagesCount(roomId);
      final index = _cachedRooms.indexWhere((r) => r.id == roomId);
      if (index != -1) {
        _cachedRooms[index].unreadMessages = count;
        emit(GetAllRoomSuccess(List.from(_cachedRooms)));
      }
    } catch (_) {}
  }

  markMessagesAsSeen(String roomId) async {
    await homeRepo.markMessagesAsSeen(roomId);
  }
}
