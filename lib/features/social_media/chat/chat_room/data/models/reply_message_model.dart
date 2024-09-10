import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/entities/message_sender_entity.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/entities/reply_message_entity.dart';

class ReplyMessageModel extends ReplyMessageEntity {
  ReplyMessageModel(
      {required super.sender,
      required super.text,
      required super.id,
      required super.media});

  factory ReplyMessageModel.fromJson(Map<String, dynamic> json) {
    return ReplyMessageModel(
      sender: MessageSenderEntity(
        name: json['userId'],
        avatar: json['username'],
        id: json['avatar'],
      ),
      text: json['text'],
      id: json['_id'],
      media: [],
    );
  }
}
