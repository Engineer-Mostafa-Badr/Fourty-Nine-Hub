import '../../../chat_room/domain/entities/message_entity.dart';
import '../../../chat_room/domain/usecases/get_lables_usecase.dart';

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
  String? lastSeen;
  MessageEntity? lastMessage;
  String? pinnedMessageId;
  MessageEntity? pinnedMessage;
  bool isSelected = false;
  bool isPinned = false;
  bool isTimerActive = false;
  bool hasStory = false;
  String? isAdmin;
  List<GetLablesEntity> lables = [];
  bool isBirthdayMonth = false;
  bool isSearching = false;
  String gender = 'male';
  String? messageDraft;
  String? fcmToken;

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
    this.isTimerActive = false,
    this.lastSeen,
    this.hasStory = false,
    this.isAdmin,
    this.lables = const [],
    this.isBirthdayMonth = false,
    this.isSearching = false,
    this.messageDraft,
    this.fcmToken,
    this.gender='male',
  });
}
