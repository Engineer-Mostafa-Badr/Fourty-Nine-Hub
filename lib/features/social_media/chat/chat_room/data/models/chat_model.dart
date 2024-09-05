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

  factory ChatModel.fromEntity(ChatEntity entity) {
    return ChatModel(
      sId: entity.sId,
      privacy: entity.privacy,
      type: entity.type,
      categoryId: entity.categoryId,
      contact: entity.contact,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      lastMessage: entity.lastMessage,
    );
  }

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      sId: json['_id'],
      contact: json['contact'] != null
          ? ContactModel.fromJson(json['contact'])
          : null,
      privacy: json['privacy'],
      type: json['type'],
      categoryId: json['categoryId'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      lastMessage: json['lastMessage'],
    );
  }

  factory ChatModel.fromDatabase(Map<String, dynamic> map) {
    return ChatModel(
      sId: map['id'],
      contact: ContactModel(
        sId: map['contactId'],
        avatar: map['contactAvatar'],
        name: map['contactName'],
      ),
      privacy: map['privacy'],
      type: map['type'],
      categoryId: map['categoryId'],
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
      lastMessage: map['lastMessage'],
    );
  }

  Map<String, dynamic> toDatabase() {
    return {
      'id': sId,
      'contactId': contact?.sId,
      'contactAvatar': contact?.avatar,
      'contactName': contact?.name,
      'privacy': privacy,
      'type': type,
      'categoryId': categoryId,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'lastMessage': lastMessage,
    };
  }
}
