import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/entities/message_entity.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/repositories/chat_room_repository.dart';

class GetChatMessagesUseCase extends UseCase<List<MessageEntity>, String> {
  final ChatRoomRepository _repo;

  GetChatMessagesUseCase(this._repo);

  @override
  Future<Either<Failure, List<MessageEntity>>> call(String params) {
    return _repo.getChatMessages(params);
  }
}
