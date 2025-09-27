import 'package:fourtyninehub/features/Conversations/Data/Models/profile_model.dart';

import '../../Domain/Entities/conversation_entity.dart';
import 'last_message_model.dart';

class ConversationModel extends ConversationEntity {
  ConversationModel({
    required super.conversationId,
    required super.unreadMessagesCount,
    required super.isOnline,
    required super.isPinned,
    required super.isMuted,
    required super.profile,
    required super.lastMessage,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    return ConversationModel(
      conversationId: json['conversationId'],
      unreadMessagesCount: json['unreadCount'] ?? 0,
      isOnline: json['isOnline'] ?? false,
      isPinned: json['isPinned'] ?? false,
      isMuted: json['isMuted'] ?? false,
      profile: json['profile'] == null ? null : ProfileModel.fromJson(json['profile']),
      lastMessage: json['lastMessage'] == null ? null : LastMessageModel.fromJson(json['lastMessage']),
    );
  }
}