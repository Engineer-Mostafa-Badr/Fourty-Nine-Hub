import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/entities/message_media_entity.dart';

import 'message_sender_entity.dart';
import 'reply_message_entity.dart';

class MessageEntity {
  String id;
  String? chatId;
  String? groupId;
  String text;
  List<MessageMediaEntity> media;
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

  MessageEntity(
      {required this.id,
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
      required this.isDeleted});

  void markAsSeen() {
    seen = true;
    delivered = true;
  }

  void markAsDelivered() {
    if (!seen) {
      delivered = true;
      seen = false;
    }
  }

  @override
  String toString() {
    return "MessageEntity: { text: $text, sender: $sender, id: $id,chatId: $chatId, reply: $reply, time: $time, byMe: $byMe, isUpdated: $isUpdated, seen: $seen, delivered: $delivered, hasReply: $hasReply, media: $media }";
  }
}
