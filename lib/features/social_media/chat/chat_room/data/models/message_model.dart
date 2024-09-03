import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/entities/message_entity.dart';

class MessageModel extends MessageEntity {
  MessageModel({
    super.id,
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

  factory MessageModel.fromEntity(MessageEntity entity) {
    return MessageModel(
      id: entity.id,
      text: entity.text,
      chatId: entity.chatId,
      groupId: entity.groupId,
      seen: entity.seen,
      delivered: entity.delivered,
      isDeleted: entity.isDeleted,
      isReply: entity.isReply,
      type: entity.type,
      sharesCount: entity.sharesCount,
      likesCount: entity.likesCount,
      loveCount: entity.loveCount,
      wowCount: entity.wowCount,
      sadCount: entity.sadCount,
      angryCount: entity.angryCount,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      formattedCreatedAt: entity.formattedCreatedAt,
      byMe: entity.byMe,
      replyMessageId: entity.replyMessageId,
    );
  }

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['_id'],
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
      formattedCreatedAt: json['formattedCreatedAt'],
      byMe: json['byMe'],
      replyMessageId: json['replyMessageId'] != null
          ? ReplyMessageModel.fromJson(json['replyMessageId'])
          : null,
    );
  }

  factory MessageModel.fromDatabase(Map<String, dynamic> map) {
    return MessageModel(
      id: map['id'],
      text: map['text'],
      chatId: map['chatId'],
      groupId: map['groupId'],
      seen: (map['seen'] != null && map['seen'] == 1) ? true : false,
      delivered:
          (map['delivered'] != null && map['delivered'] == 1) ? true : false,
      isDeleted:
          (map['isDeleted'] != null && map['isDeleted'] == 1) ? true : false,
      isReply: (map['isReply'] != null && map['isReply'] == 1) ? true : false,
      type: map['type'],
      sharesCount: map['sharesCount'],
      likesCount: map['likesCount'],
      loveCount: map['loveCount'],
      wowCount: map['wowCount'],
      sadCount: map['sadCount'],
      angryCount: map['angryCount'],
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
      formattedCreatedAt: map['formattedCreatedAt'],
      byMe: (map['byMe'] != null && map['byMe'] == 1) ? true : false,
      replyMessageId: ReplyMessageModel(
          id: map['replyMessageId'], text: map['replyMessageText']),
    );
  }

  Map<String, dynamic> toDatabase() {
    Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['text'] = text;
    data['chatId'] = chatId;
    data['groupId'] = groupId;
    data['seen'] = (seen ?? false) ? 1 : 0;
    data['delivered'] = (delivered ?? false) ? 1 : 0;
    data['isDeleted'] = (isDeleted ?? false) ? 1 : 0;
    data['isReply'] = (isReply ?? false) ? 1 : 0;
    data['type'] = type;
    data['sharesCount'] = sharesCount;
    data['likesCount'] = likesCount;
    data['loveCount'] = loveCount;
    data['wowCount'] = wowCount;
    data['sadCount'] = sadCount;
    data['angryCount'] = angryCount;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['formattedCreatedAt'] = formattedCreatedAt;
    data['byMe'] = (byMe ?? false) ? 1 : 0;
    data['replyMessageId'] = replyMessageId?.id;
    data['replyMessageText'] = replyMessageId?.text;

    return data;
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

  factory ReplyMessageModel.fromDatabase(Map<String, dynamic> map) {
    return ReplyMessageModel(
      id: map['id'],
      text: map['text'],
    );
  }

  Map<String, dynamic> toDatabase() {
    Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['text'] = text;
    return data;
  }
}
