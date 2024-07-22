import 'package:fourtyninehub/features/social_media/chat/data/models/contact_model.dart';
import 'package:fourtyninehub/features/social_media/chat/domain/entities/chat_entity.dart';

class ChatModel extends ChatEntity {
  ChatModel(
      {super.sId,
      super.privacy,
      super.type,
      super.categoryId,
      super.contacts,
      super.createdAt,
      super.updatedAt,
      super.lastMessage});

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      sId: json['_id'],
      contacts: json['contacts'] == null
          ? []
          : (json['contacts'] as List)
              .map((e) => Contacts.fromJson(e))
              .toList(),
      privacy: json['privacy'],
      type: json['type'],
      categoryId: json['categoryId'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      lastMessage: json['lastMessage'],
    );
  }
}
