import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/repositories/chats_repository.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/usecases/lock_chat_request.dart';

class LockChatUseCase extends UseCase<bool, LockChatParams> {
  final ChatsRepository _chatsRepository;

  LockChatUseCase(this._chatsRepository);

  @override
  Future<Either<Failure, bool>> call(LockChatParams params) {
    return _chatsRepository.lockChat(params);
  }
}
