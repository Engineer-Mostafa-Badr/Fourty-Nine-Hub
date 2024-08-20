import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/entities/contact_entity.dart';

class Contact extends ContactEntity {
  Contact({super.sId, super.avatar, super.name});

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      sId: json['sId'],
      avatar: json['avatar'],
      name: json['name'],
    );
  }
}
