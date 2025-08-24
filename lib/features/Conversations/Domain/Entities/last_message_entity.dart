import 'package:fourtyninehub/features/Conversations/Domain/Entities/message_type_enum.dart';
import 'package:fourtyninehub/features/Conversations/Domain/Entities/sender_entity.dart';

class LastMessageEntity {
  final String id;
  final MessageTypeEnum type;
  final String? content;
  final DateTime? createdAt;
  final SenderEntity? sender;

  LastMessageEntity({
    required this.id,
    required this.type,
    this.content,
    this.createdAt,
    this.sender,
  });
}