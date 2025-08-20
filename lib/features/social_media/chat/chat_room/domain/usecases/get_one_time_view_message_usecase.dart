import 'package:dartz/dartz.dart';
import '../../../../../../core/abstract/use_case.dart';
import '../../../../../../core/error/failure.dart';
import '../entities/message_entity.dart';
import '../repositories/chat_room_repository.dart';

class GetOneTimeViewMessageUseCase
    extends UseCase<MessageEntity, GetOneTimeViewMessageParams> {
  final ChatRoomRepository _chatRoomRepository;

  GetOneTimeViewMessageUseCase(this._chatRoomRepository);

  @override
  Future<Either<Failure, MessageEntity>> call(
      GetOneTimeViewMessageParams params) async {
    return _chatRoomRepository.getOneTimeViewMessage(params);
  }
}

class GetOneTimeViewMessageParams {
  final String chatId;
  final String messageId;

  GetOneTimeViewMessageParams({required this.chatId, required this.messageId});
}
