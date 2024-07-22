import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/social_media/chat/domain/entities/message_entity.dart';
import 'package:fourtyninehub/features/social_media/chat/domain/repositories/chat_repository.dart';

class ChatRepositoryImplementation extends ChatRepository {
  @override
  Future<Either<Failure, List<MessageEntity>>> getChatMessages() {
    throw UnimplementedError();
  }
}
