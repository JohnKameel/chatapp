import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chat_app/features/home/data/repo/home_repo.dart';
import 'package:meta/meta.dart';

import '../../data/model/room_model.dart';

part 'room_state.dart';

class RoomCubit extends Cubit<RoomState> {
  HomeRepo homeRepo;
  RoomCubit(this.homeRepo) : super(RoomInitial());

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

  getAllRooms() {
    emit(GetAllRoomLoading());

    try{
      roomSubscription = homeRepo.getAllRooms().listen((rooms) async {
        List<RoomModel> roomWithUsers = [];

        for (var room in rooms) {
          final anotherId = room.members
              .where((id) => id != homeRepo.supabaseService.currentUserId)
              .first;

          final user = await homeRepo.getUserInfo(anotherId);
          user.fold((failure) {
            emit(GetAllRoomFailure(failure.message));
          }, (user) {
            room.otherUserInfo = user;
            roomWithUsers.add(room);
          });
        }
        emit(GetAllRoomSuccess(roomWithUsers));
      });
    }catch(e){
      emit(GetAllRoomFailure(e.toString()));
    }
  }

  Future<void> updateUnreadCounts(List<RoomModel> rooms) async {
    for (var room in rooms) {
      final count = await homeRepo.getUnreadMessagesCount(room.id);
      room.unreadMessages = count;
    }

    emit(GetAllRoomSuccess(List.from(rooms)));
  }

  markMessagesAsSeen(String roomId) async {
      await homeRepo.markMessagesAsSeen(roomId);
  }
}
