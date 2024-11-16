import 'package:fourtyninehub/features/social_media/chat/chat_room/data/models/message_media_model.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/data/models/message_shared_contacts_model.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/data/models/reply_message_model.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/entities/message_entity.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/entities/message_sender_entity.dart';
import 'package:fourtyninehub/res/style/const.dart';

class MessageModel extends MessageEntity {
  MessageModel({
    required super.id,
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
    required super.time,
    required super.sharedContacts,
    required super.isOneTimeViewMessage,
    required super.isOneTimeSeenMessage,
    required super.isListened,
    required super.isForwarded,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['_id'] ?? '',
      text: json['text'] ?? '',
      media: json['media'] != null
          ? (json['media'] as List)
              .whereType<
                  Map<String, dynamic>>() // Only keep items that are maps
              .map((e) => MessageMediaModel.fromJson(e))
              .toList()
          : [],
      sender: MessageSenderEntity(
        id: json['ownerUserId'] ?? '',
        name: json['username'] ?? '',
        avatar: json['avatar'] ?? UIConst.profilePlaceHolder,
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
      byMe: json['byMe'] ?? false,
      isUpdated: json['isUpdated'] ?? false,
      seen: json['seen'] ?? false,
      delivered: json['delivered'] ?? false,
      hasReply: json['isReply'] ?? false,
      time: json['formattedCreatedAt'] ?? '00:00',
      isDeleted: json['isDeleted'] ?? false,
      chatId: json['chatId'],
      groupId: json['groupId'],
      sharedContacts: json['sharedContacts'] != null
          ? (json['sharedContacts'] as List)
              .whereType<
                  Map<String, dynamic>>() // Only keep items that are maps
              .map((e) => MessageSharedContactsModel.fromJson(e))
              .toList()
          : [],
      isOneTimeViewMessage: json['oneTimeView'] ?? false,
      isOneTimeSeenMessage: json['oneTimeSeen'] ?? false,
      isListened: json['listen'] ?? false,
      isForwarded: json['isForward'] ?? false,
    );
  }
}
