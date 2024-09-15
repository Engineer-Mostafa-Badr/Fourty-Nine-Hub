import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/entities/message_sender_entity.dart';

class ReplyMessageEntity {
  String id;
  String text;
  MessageSenderEntity sender;
  List<String> media;

  ReplyMessageEntity(
      {required this.sender,
      required this.text,
      required this.id,
      required this.media});
}
