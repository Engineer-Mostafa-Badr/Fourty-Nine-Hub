import 'package:dartz/dartz.dart';
import '../../../../../../core/abstract/use_case.dart';
import '../../../../../../core/error/failure.dart';
import '../../../chat_room/domain/entities/message_entity.dart';
import '../repositories/chats_repository.dart';

class ShowDeletedMessageUseCase
    extends UseCase<MessageEntity, ShowDeletedMessageParams> {
  final ChatsRepository _chatsRepository;

  ShowDeletedMessageUseCase(this._chatsRepository);

  @override
  Future<Either<Failure, MessageEntity>> call(
      ShowDeletedMessageParams params) async {
    return await _chatsRepository.showDeletedMessage(params);
  }
}

class ShowDeletedMessageParams {
  final String chatId;
  final String messageId;

  ShowDeletedMessageParams({required this.chatId, required this.messageId});
}
