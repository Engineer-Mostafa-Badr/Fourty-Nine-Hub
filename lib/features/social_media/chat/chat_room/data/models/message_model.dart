import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/entities/message_entity.dart';

class MessageModel extends MessageEntity {
  MessageModel({
    super.sId,
    super.text,
    super.chatId,
    super.groupId,
    super.seen,
    super.delivered,
    super.isDeleted,
    super.isReply,
    super.type,
    super.sharesCount,
    super.likesCount,
    super.loveCount,
    super.wowCount,
    super.sadCount,
    super.angryCount,
    super.createdAt,
    super.updatedAt,
    super.byMe,
    super.formattedCreatedAt,
    super.replyMessageId,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      sId: json['_id'],
      text: json['text'],
      chatId: json['chatId'],
      groupId: json['groupId'],
      seen: json['seen'],
      delivered: json['delivered'],
      isDeleted: json['isDeleted'],
      isReply: json['isReply'] ?? false,
      type: json['type'],
      sharesCount: json['sharesCount'],
      likesCount: json['likesCount'],
      loveCount: json['loveCount'],
      wowCount: json['wowCount'],
      sadCount: json['sadCount'],
      angryCount: json['angryCount'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      formattedCreatedAt: json['formattedCreatedAt'],
      byMe: json['byMe'],
      replyMessageId: json['replyMessageId'] != null
          ? ReplyMessageModel.fromJson(json['replyMessageId'])
          : null,
    );
  }
}

class ReplyMessageModel extends ReplyMessage {
  ReplyMessageModel({super.id, super.text});

  factory ReplyMessageModel.fromJson(Map<String, dynamic> json) {
    return ReplyMessageModel(
      id: json['_id'],
      text: json['text'],
    );
  }
}
