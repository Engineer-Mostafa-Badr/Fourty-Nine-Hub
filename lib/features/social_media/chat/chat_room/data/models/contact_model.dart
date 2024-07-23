
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/entities/contact_entity.dart';

class Contacts extends ContactEntity {
  Contacts({super.sId, super.name});

  factory Contacts.fromJson(Map<String, dynamic> json) {
    return Contacts(
      sId: json['_id'],
      name: json['name'],
    );
  }
}
