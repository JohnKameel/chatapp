part of 'messages_cubit.dart';

@immutable
sealed class MessagesState {}

final class MessagesInitial extends MessagesState {}
final class MessagesLoading extends MessagesState {}
final class MessagesSuccess extends MessagesState {
  List<MessageModel> messages;
  MessagesSuccess(this.messages);
}
final class MessagesFailure extends MessagesState {
  final String error;

  MessagesFailure(this.error);
}


final class SendMessageLoading extends MessagesState {}
final class SendMessageSuccess extends MessagesState {
  final String message;

  SendMessageSuccess(this.message);
}
final class SendMessageFailure extends MessagesState {
  final String error;

  SendMessageFailure(this.error);
}
