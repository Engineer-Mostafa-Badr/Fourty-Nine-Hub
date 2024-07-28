import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/repositories/chats_repository.dart';

class UnLockChatUseCase extends UseCase<bool, String> {
  final ChatsRepository _chatsRepository;

  UnLockChatUseCase(this._chatsRepository);

  @override
  Future<Either<Failure, bool>> call(String params) {
    return _chatsRepository.unLockChat(params);
  }
}
