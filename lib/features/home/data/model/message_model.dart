import 'package:json_annotation/json_annotation.dart';

part 'message_model.g.dart';

@JsonSerializable()
class MessageModel {
  final String roomId;
  final String senderId;
  final String content;
  final DateTime createdAt;
  final List<String>? seenBy;

  MessageModel({
    required this.roomId,
    required this.senderId,
    required this.content,
    required this.createdAt,
    this.seenBy,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) => _$MessageModelFromJson(json);

  Map<String, dynamic> toJson() => _$MessageModelToJson(this);
}