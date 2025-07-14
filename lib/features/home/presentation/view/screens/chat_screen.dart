import 'package:chat_app/core/database/supabase_service.dart';
import 'package:chat_app/features/home/data/model/room_model.dart';
import 'package:chat_app/features/home/data/repo/home_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/server_locator/server_locator.dart';
import '../../viewModel/messages_cubit.dart';
import '../../viewModel/room_cubit.dart';

class ChatScreen extends StatefulWidget {
  final RoomModel? roomModel;

  const ChatScreen({super.key, required this.roomModel});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController messageController = TextEditingController();
  late final MessagesCubit messagesCubit;

  @override
  void initState() {
    super.initState();
    final roomId = widget.roomModel!.id;
    context.read<MessagesCubit>().getAllMessages(widget.roomModel!.id);
    context.read<MessagesCubit>().markMessagesAsSeen(roomId).then((_) {
      context.read<RoomCubit>().updateUnreadCounts(roomId);
    });
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final myId = SupabaseService().client.auth.currentUser!.id;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.roomModel!.otherUserInfo!.user_name),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // list
          BlocBuilder<MessagesCubit, MessagesState>(
            builder: (context, state) {
              if (state is MessagesLoading) {
                return Center(child: CircularProgressIndicator());
              }
              if (state is MessagesFailure) {
                return Center(child: Text(state.error));
              }
              if (state is MessagesSuccess) {
                final messages = state.messages;
                if (messages.isEmpty) {
                  return Center(child: Text('No messages yet'));
                }
                return Expanded(
                  child: ListView.builder(
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      bool isMe = messages[index].senderId == myId;
                      final message = messages[index];

                      return Align(
                        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isMe ? Colors.blue[100] : Colors.grey[300],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            message.content,
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      );
                    },
                  ),
                );
              }
              return Container();
            },
          ),
          // textfield and send button
          Padding(
            padding: const EdgeInsets.only(left: 14,bottom: 15, right: 4),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                BlocBuilder<MessagesCubit, MessagesState>(
                  builder: (context, state) {
                    if (state is SendMessageLoading) {
                      return CircularProgressIndicator();
                    }
                    return IconButton(
                      onPressed: () {
                        context.read<MessagesCubit>().sendMessage(
                              widget.roomModel!.id,
                              messageController.text,
                            );
                        messageController.clear();
                      },
                      icon: Icon(Icons.send_rounded),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
