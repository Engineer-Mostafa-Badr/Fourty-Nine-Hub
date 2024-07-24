import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/entities/message_entity.dart';

abstract class ChatRoomRepository {
  Future<Either<Failure, List<MessageEntity>>> getChatMessages(String chatId);
}
