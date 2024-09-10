import 'package:flutter/material.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/presentation/views/widgets/date_time_picker_v2.dart';

import 'message_sender_entity.dart';
import 'reply_message_entity.dart';

class MessageEntity {
  String id;
  String? chatId;
  String? groupId;
  String text;
  List<String> media;
  MessageSenderEntity sender;
  ReplyMessageEntity? reply;
  DateTime createdAt;
  DateTime updateAt;
  String time;
  bool byMe;
  bool isUpdated;
  bool seen;
  bool delivered;
  bool hasReply;
  bool isDeleted;


  MessageEntity({
    required this.id,
    required this.text,
    required this.media,
    required this.sender,
    required this.reply,
    required this.createdAt,
    required this.updateAt,
    required this.byMe,
    required this.isUpdated,
    required this.seen,
    required this.delivered,
    required this.hasReply,
    this.chatId,
    this.groupId,
    required this.time,
    required this.isDeleted
  });


}
