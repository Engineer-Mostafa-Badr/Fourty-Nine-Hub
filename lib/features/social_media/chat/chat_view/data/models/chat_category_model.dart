import 'chat_model.dart';
import '../../domain/entities/chat_category_entity.dart';

class ChatCategoryModel extends ChatCategoryEntity {
  ChatCategoryModel({required super.chats, required super.totalUnreadMessages});

  factory ChatCategoryModel.fromJson(Map<String, dynamic> json) {
    return ChatCategoryModel(
        chats: json['chats'] != null
            ? (json['chats'] as List).map((i) => ChatModel.fromJson(i)).toList()
            : [],
        totalUnreadMessages: json['totalUnread']);
  }
}
