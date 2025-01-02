import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/entities/message_entity.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/repositories/chats_repository.dart';

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
