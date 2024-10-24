import 'package:fourtyninehub/core/extensions/file_extension.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/entities/message_media_entity.dart';

class MessageMediaModel extends MessageMediaEntity {
  MessageMediaModel(
      {required super.id,
      required super.url,
      required super.type,
      super.fileName,
      super.fileSize});

  factory MessageMediaModel.fromJson(Map<String, dynamic> json) {
    return MessageMediaModel(
      id: json['_id'],
      url: json['mediaKey'],
      type: (json['mimetype'] as String).split('/').first.getFileTypeEnum(),
      fileName: json['fileName'],
      fileSize: json['size'],
    );
  }

  toJson() {
    return {
      '_id': id,
      'mediaKey': url,
      'mimetype': type.name,
      'fileName': fileName,
      'fileSize': fileSize,
    };
  }
}
