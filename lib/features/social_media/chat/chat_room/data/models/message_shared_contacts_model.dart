import 'package:fourtyninehub/core/extensions/file_extension.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/entities/message_media_entity.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/entities/message_shared_contacts_entity.dart';

class MessageSharedContactsModel extends MessageSharedContactsEntity {
  MessageSharedContactsModel(
      {required super.name, required super.phoneNumber, super.avatar});

  factory MessageSharedContactsModel.fromJson(Map<String, dynamic> json) {
    return MessageSharedContactsModel(
      name: json['name'],
      phoneNumber: json['phoneNumber'],
      avatar: json['avatar'],
    );
  }
}
