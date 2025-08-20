import 'message_sender_entity.dart';

import 'message_media_entity.dart';

class ReplyMessageEntity {
  String id;
  String text;
  MessageSenderEntity sender;
  List<MessageMediaEntity> media;

  ReplyMessageEntity(
      {required this.sender,
      required this.text,
      required this.id,
      required this.media});
}
