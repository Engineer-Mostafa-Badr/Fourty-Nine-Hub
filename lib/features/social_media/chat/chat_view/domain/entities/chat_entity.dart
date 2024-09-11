import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/entities/message_entity.dart';

class ChatEntity {
  String id;
  String categoryId;
  bool isService;
  bool archived;
  bool locked;
  bool muted;
  String name;
  int lastSeenCount;
  int unreadCount;
  String userId;
  String avatar;
  bool typing;
  bool online;
  MessageEntity? lastMessage;
  bool isSelected = false;

  ChatEntity({
    required this.id,
    required this.isService,
    required this.categoryId,
    required this.archived,
    required this.locked,
    required this.muted,
    required this.name,
    required this.lastSeenCount,
    required this.unreadCount,
    required this.userId,
    required this.avatar,
    required this.typing,
    required this.online,
    this.lastMessage,
    this.isSelected = false,
  });
}
