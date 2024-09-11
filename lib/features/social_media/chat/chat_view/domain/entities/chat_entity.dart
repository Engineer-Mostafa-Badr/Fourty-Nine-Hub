class ChatEntity {
  String id;
  String categoryId;
  bool isService;
  bool archived;
  bool locked;
  bool muted;
  String updatedAt;
  bool isLastMessageByMe;
  bool seen;
  bool delivered;
  String lastMessageText;
  String name;
  int lastSeenCount;
  int unreadCount;
  String formattedUpdatedAt;
  String userId;
  String avatar;
  bool typing;
bool online;
  ChatEntity({
    required this.id,
    required this.isService,
    required this.categoryId,
    required this.archived,
    required this.locked,
    required this.muted,
    required this.updatedAt,
    required this.isLastMessageByMe,
    required this.seen,
    required this.delivered,
    required this.lastMessageText,
    required this.name,
    required this.lastSeenCount,
    required this.unreadCount,
    required this.formattedUpdatedAt,
    required this.userId,
    required this.avatar,
    required this.typing,
    required this.online,
  });

}
