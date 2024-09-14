import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/entities/chat_entity.dart';

class ChatCategoryEntity {
  List<ChatEntity> chats;

  int totalUnreadMessages;

  ChatCategoryEntity({required this.chats, required this.totalUnreadMessages});
}
