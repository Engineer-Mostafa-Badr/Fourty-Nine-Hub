import 'chat_entity.dart';

class ChatCategoryEntity {
  List<ChatEntity> chats;

  int totalUnreadMessages;

  ChatCategoryEntity({required this.chats, required this.totalUnreadMessages});
}
