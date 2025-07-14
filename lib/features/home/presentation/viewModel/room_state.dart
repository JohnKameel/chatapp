part of 'room_cubit.dart';

@immutable
sealed class RoomState {}

final class RoomInitial extends RoomState {}

final class CreateRoomLoading extends RoomState {}
final class CreateRoomSuccess extends RoomState {
  final String message;
  CreateRoomSuccess(this.message);
}
final class CreateRoomFailure extends RoomState {
  final String error;
  CreateRoomFailure(this.error);
}

final class GetAllRoomLoading extends RoomState {}
final class GetAllRoomSuccess extends RoomState {
  final List<RoomModel> rooms;
  GetAllRoomSuccess(this.rooms);
}
final class GetAllRoomFailure extends RoomState {
  final String error;
  GetAllRoomFailure(this.error);
}
