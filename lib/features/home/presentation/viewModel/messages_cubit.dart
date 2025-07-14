import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chat_app/features/home/data/repo/home_repo.dart';
import 'package:meta/meta.dart';

import '../../data/model/message_model.dart';

part 'messages_state.dart';

class MessagesCubit extends Cubit<MessagesState> {
  HomeRepo homeRepo;
  MessagesCubit(this.homeRepo) : super(MessagesInitial());

  sendMessage(roomId, content) async {
    emit(SendMessageLoading());
    try {
      await homeRepo.sendMessage(roomId, content);
      emit(SendMessageSuccess("send message success"));
      getAllMessages(roomId);
    } catch (e) {
      emit(SendMessageFailure("Failed to send message: $e"));
    }
  }

  StreamSubscription <List<MessageModel>>? messagesSubscription;

  getAllMessages(roomId) {
    emit(MessagesLoading());
    messagesSubscription = homeRepo.getAllMessages(roomId).listen((messages) {
      emit(MessagesSuccess(messages));
    }, onError: (error) {
      emit(MessagesFailure("Failed to fetch messages: $error"));
    });
  }

  Future<void> markMessagesAsSeen(String roomId) async {
    try {
      await homeRepo.markMessagesAsSeen(roomId);
    } catch (e) {
      if (!isClosed) emit(MessagesFailure("Failed to mark messages as seen: $e"));
    }
  }

  @override
  Future<void> close() {
    messagesSubscription?.cancel();
    return super.close();
  }
}
