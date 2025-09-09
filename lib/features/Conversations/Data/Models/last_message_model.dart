import 'package:fourtyninehub/features/Conversations/Data/Models/sender_model.dart';
import 'package:fourtyninehub/features/Conversations/Domain/Entities/last_message_entity.dart';

import '../../Domain/Entities/message_type_enum.dart';

class LastMessageModel extends LastMessageEntity {
  LastMessageModel({
    required super.id,
    required super.type,
    required super.content,
    required super.createdAt,
    required super.sender,
  });

  factory LastMessageModel.fromJson(Map<String, dynamic> json) {
    return LastMessageModel(
      id: json['id'],
      type: json['type'] == null ? MessageTypeEnum.text : MessageTypeEnum.fromString(json['type']),
      content: json['content'],
      createdAt: json['createdAt'] == null ? DateTime.now() : DateTime.parse(json['createdAt']),
      sender: json['sender'] == null ? null : SenderModel.fromJson(json['sender']),
    );
  }
}