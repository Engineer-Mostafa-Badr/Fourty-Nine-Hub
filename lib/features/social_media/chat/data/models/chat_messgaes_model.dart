import 'package:fourtyninehub/features/social_media/chat/data/models/chat_model.dart';
import 'package:fourtyninehub/features/social_media/chat/domain/entities/chat_messgaes_entity.dart';

import 'message_model.dart';

class ChatMessagesModel extends ChatMessageEntity {
  ChatMessagesModel({super.chat, super.messages});

  factory ChatMessagesModel.fromJson(Map<String, dynamic> json) {
    return ChatMessagesModel(
      chat: json['chat'] != null ? ChatModel.fromJson(json['chat']) : null,
      messages: json['messages'] == null
          ? []
          : (json['messages'] as List)
              .map((e) => MessageModel.fromJson(e))
              .toList(),
    );
  }
}
