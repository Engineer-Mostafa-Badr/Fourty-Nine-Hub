

import 'package:fourtyninehub/features/social_media/chat/chat_room/data/models/contact_model.dart';

class ChatEntity {
  String? sId;
  String? privacy;
  String? type;
  String? categoryId;
  List<Contacts>? contacts;
  String? createdAt;
  String? updatedAt;
  String? lastMessage;

  ChatEntity(
      {this.sId,
        this.privacy,
        this.type,
        this.categoryId,
        this.contacts,
        this.createdAt,
        this.updatedAt,
        this.lastMessage});

}