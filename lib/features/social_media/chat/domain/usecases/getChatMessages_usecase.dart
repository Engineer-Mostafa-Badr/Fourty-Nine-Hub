import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/social_media/chat/domain/entities/message_entity.dart';
import 'package:fourtyninehub/features/social_media/chat/domain/repositories/chat_repository.dart';

class GetChatMessagesUseCase extends UseCase<List<MessageEntity>, String> {
  final ChatRepository _repo;

  GetChatMessagesUseCase(this._repo);

  @override
  Future<Either<Failure, List<MessageEntity>>> call(String chatId) {
    return _repo.getChatMessages();
  }
}
