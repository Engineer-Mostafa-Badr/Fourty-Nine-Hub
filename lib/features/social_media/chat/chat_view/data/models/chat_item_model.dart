import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/entities/chat_entity.dart';

class ChatItemModel {
  List<ChatModel>? chats;
  int? totalUnread;

  ChatItemModel({this.chats, this.totalUnread});

  ChatItemModel.fromJson(Map<String, dynamic> json) {
    if (json['chats'] != null) {
      chats = <ChatModel>[];
      json['chats'].forEach((v) {
        chats!.add(ChatModel.fromJson(v));
      });
    } else if (json['groups'] != null) {
      chats = <ChatModel>[];
      json['groups'].forEach((v) {
        chats!.add(ChatModel.fromJson(v));
      });
    }
    totalUnread = json['totalUnread'];
  }
}

class ChatModel extends ChatEntity {
  ChatModel(
      {required super.id,
      required super.categoryId,
      required super.archived,
      required super.locked,
      required super.muted,
      required super.updatedAt,
      required super.isLastMessageByMe,
      required super.seen,
      required super.delivered,
      required super.lastMessageText,
      required super.name,
      required super.lastSeenCount,
      required super.unreadCount,
      required super.formattedUpdatedAt,
      required super.userId,
      required super.typing,
      required super.avatar,
      required super.online,
      });

  factory ChatModel.fromJson(Map<String, dynamic> json) => ChatModel(
        id: json['_id'],
        categoryId: json['categoryId'],
        archived: json['archived'],
        locked: json['locked'],
        muted: json['muted'],
        updatedAt: json['updatedAt'],
        isLastMessageByMe: json['isLastMessageByMe'],
        seen: json['seen'],
        delivered: json['delivered'],
        lastMessageText: json['lastMessageText'],
        name: json['name'],
        lastSeenCount: json['lastSeenCount'],
        unreadCount: json['unreadCount'],
        formattedUpdatedAt: json['formattedUpdatedAt'],
        userId: json['userId'],
        avatar: json['avatar'],
        typing: false,
        online: false,
      );
}
