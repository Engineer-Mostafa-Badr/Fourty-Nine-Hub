import 'package:fourtyninehub/features/social_media/chat/chat_room/data/models/message_model.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/entities/chat_entity.dart';

class ChatModel extends ChatEntity {
  ChatModel({
    required super.id,
    required super.categoryId,
    required super.archived,
    required super.locked,
    required super.muted,
    required super.name,
    required super.lastSeenCount,
    required super.unreadCount,
    required super.userId,
    required super.typing,
    required super.avatar,
    required super.online,
    required super.isService,
    super.lastMessage,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) => ChatModel(
        id: json['_id'],
        categoryId: json['categoryId'],
        archived: json['archived'],
        locked: json['locked'],
        muted: json['muted'],
        name: json['name'],
        lastSeenCount: json['lastSeenCount'],
        unreadCount: json['unreadCount'],
        userId: json['userId'],
        avatar: json['avatar'],
        typing: false,
        online: false,
        isService: json['isService'] ?? false,
        lastMessage: json['lastMessage'] != null
            ? MessageModel.fromJson(json['lastMessage'])
            : null,
      );
}
