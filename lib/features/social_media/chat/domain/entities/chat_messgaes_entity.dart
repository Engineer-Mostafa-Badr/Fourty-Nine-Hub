import 'package:fourtyninehub/features/social_media/chat/data/models/chat_model.dart';
import 'package:fourtyninehub/features/social_media/chat/data/models/message_model.dart';
import 'package:fourtyninehub/features/social_media/chat/domain/entities/chat_entity.dart';
import 'package:fourtyninehub/features/social_media/chat/domain/entities/message_entity.dart';

class ChatMessageEntity {
  ChatEntity? chat;
  List<MessageEntity>? messages;

  ChatMessageEntity({this.chat, this.messages});
}
