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
  bool typing = false;
  bool recording = false;
  bool online;
  MessageEntity? lastMessage;
  String? pinnedMessageId;
  MessageEntity? pinnedMessage;
  bool isSelected = false;
  bool isPinned = false;

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
    this.typing = false,
    this.recording = false,
    required this.online,
    this.lastMessage,
    this.pinnedMessage,
    this.pinnedMessageId,
    this.isSelected = false,
    this.isPinned = false,
  });
}
