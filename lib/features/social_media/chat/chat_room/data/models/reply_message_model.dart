import '../../domain/entities/message_sender_entity.dart';
import '../../domain/entities/reply_message_entity.dart';
import '../../../../../../res/style/const.dart';

import 'message_media_model.dart';

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
      text: json['text'] ?? 'no message',
      id: json['_id'] ?? 'no id',
      media: json['media'] != null
          ? (json['media'] as List)
              .whereType<
                  Map<String, dynamic>>() // Only keep items that are maps
              .map((e) => MessageMediaModel.fromJson(e))
              .toList()
          : [],
    );
  }
}
