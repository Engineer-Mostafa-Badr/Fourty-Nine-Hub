import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/entities/contact_entity.dart';

class ContactModel extends ContactEntity {
  ContactModel({super.sId, super.avatar, super.name});

  factory ContactModel.fromJson(Map<String, dynamic> json) {
    return ContactModel(
      sId: json['sId'],
      avatar: json['avatar'],
      name: json['name'],
    );
  }
}
