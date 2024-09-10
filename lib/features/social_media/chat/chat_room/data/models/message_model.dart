import 'package:fourtyninehub/features/social_media/chat/chat_room/data/models/reply_message_model.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/entities/message_entity.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/entities/message_sender_entity.dart';

class MessageModel extends MessageEntity {
  MessageModel(
      {required super.id,
      required super.text,
      required super.media,
      required super.sender,
      required super.reply,
      required super.createdAt,
      required super.updateAt,
      required super.byMe,
      super.chatId,
      super.groupId,
      required super.isUpdated,
      required super.seen,
      required super.delivered,
      required super.hasReply,
      required super.isDeleted,
      required super.time});

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['_id'],
      text: json['text'],
      media: [],
      sender: MessageSenderEntity(
        id: json['ownerUserId'],
        name: json['username'],
        avatar: json['avatar'],
      ),
      reply: json['replyMessage'] != null
          ? ReplyMessageModel.fromJson(json['replyMessage'])
          : null,
      createdAt: (json['createdAt'] != null && json['createdAt'] != "")
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updateAt: (json['updatedAt'] != null && json['updatedAt'] != "")
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
      byMe: json['byMe'],
      isUpdated: json['isUpdated'],
      seen: json['seen'],
      delivered: json['delivered'],
      hasReply: json['isReply'],
      time: json['formattedCreatedAt'],
      isDeleted: json['isDeleted'],
      chatId: json['chatId'],
      groupId: json['groupId'],
    );
  }
}
