import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/social_media/chat/domain/entities/message_entity.dart';

abstract class ChatRepository {
  Future<Either<Failure, List<MessageEntity>>> getChatMessages();
}
