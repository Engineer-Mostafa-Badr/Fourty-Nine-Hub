import 'package:fourtyninehub/core/extensions/file_extension.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/entities/message_media_entity.dart';

class MessageMediaModel extends MessageMediaEntity {
  MessageMediaModel(
      {required super.id, required super.url, required super.type});

  factory MessageMediaModel.fromJson(Map<String, dynamic> json) {
    return MessageMediaModel(
      id: json['_id'],
      url: json['mediaKey'],
      type: (json['mimetype'] as String).split('/').first.getFileTypeEnum(),
    );
  }

  toJson() {
    return {
      '_id': id,
      'mediaKey': url,
      'mimetype': type.name,
    };
  }
}
