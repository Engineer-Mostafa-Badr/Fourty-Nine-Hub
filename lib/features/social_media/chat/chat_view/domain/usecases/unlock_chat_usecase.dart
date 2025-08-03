import 'package:dartz/dartz.dart';
import '../../../../../../core/abstract/use_case.dart';
import '../../../../../../core/error/failure.dart';
import '../repositories/chats_repository.dart';
import 'lock_chat_request.dart';

class UnLockChatUseCase extends UseCase<bool, LockChatParams> {
  final ChatsRepository _chatsRepository;

  UnLockChatUseCase(this._chatsRepository);

  @override
  Future<Either<Failure, bool>> call(LockChatParams params) {
    return _chatsRepository.unLockChat(params);
  }
}
