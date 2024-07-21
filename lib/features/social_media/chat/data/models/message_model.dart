import 'package:fourtyninehub/features/social_media/chat/domain/entities/message_entity.dart';

class MessageModel extends MessageEntity {
  MessageModel(
      {super.sId,
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
      super.updatedAt});

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      sId: json['_id'],
      text: json['text'],
      chatId: json['chatId'],
      groupId: json['groupId'],
      seen: json['seen'],
      delivered: json['delivered'],
      isDeleted: json['isDeleted'],
      isReply: json['isReply'],
      type: json['type'],
      sharesCount: json['sharesCount'],
      likesCount: json['likesCount'],
      loveCount: json['loveCount'],
      wowCount: json['wowCount'],
      sadCount: json['sadCount'],
      angryCount: json['angryCount'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}
