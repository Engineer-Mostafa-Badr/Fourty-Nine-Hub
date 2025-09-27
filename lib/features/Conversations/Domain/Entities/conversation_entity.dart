import 'package:fourtyninehub/features/Conversations/Domain/Entities/last_message_entity.dart';
import 'package:fourtyninehub/features/Conversations/Domain/Entities/profile_entity.dart';

class ConversationEntity {
  final String conversationId;
  final int unreadMessagesCount;
  bool isOnline;
  bool isPinned;
  bool isMuted;
  final ProfileEntity? profile;
  final LastMessageEntity? lastMessage;
  bool isTyping = false;
  bool isRecording = false;
  bool inConversation = false;
  bool isSelected = false;

  ConversationEntity({
    required this.conversationId,
    required this.unreadMessagesCount,
    required this.isOnline,
    required this.isPinned,
    required this.isMuted,
    required this.profile,
    required this.lastMessage,
  });
}