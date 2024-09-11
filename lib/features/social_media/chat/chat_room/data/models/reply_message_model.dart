import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/entities/message_sender_entity.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/entities/reply_message_entity.dart';
import 'package:fourtyninehub/res/style/const.dart';

class ReplyMessageModel extends ReplyMessageEntity {
  ReplyMessageModel(
      {required super.sender,
      required super.text,
      required super.id,
      required super.media});

  factory ReplyMessageModel.fromJson(Map<String, dynamic> json) {
    return ReplyMessageModel(
      sender: MessageSenderEntity(
        name: json['username'] ?? 'no name',
        avatar: json['avatar'] ?? UIConst.profilePlaceHolder,
        id: json['userId'] ?? 'no id',
      ),
      text: json['text']??'no message',
      id: json['_id']??'no id',
      media: [],
    );
  }
}
