import 'package:fourtyninehub/features/social_media/chat/chat_room/data/models/contact_model.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/entities/chat_entity.dart';

class ChatModel extends ChatEntity {
  ChatModel(
      {super.sId,
      super.privacy,
      super.type,
      super.categoryId,
      super.contact,
      super.createdAt,
      super.updatedAt,
      super.lastMessage});

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      sId: json['_id'],
      contact:
          json['contact'] != null ? Contact.fromJson(json['contact']) : null,
      privacy: json['privacy'],
      type: json['type'],
      categoryId: json['categoryId'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      lastMessage: json['lastMessage'],
    );
  }
}
