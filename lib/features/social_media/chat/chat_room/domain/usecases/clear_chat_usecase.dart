import 'package:dartz/dartz.dart';
import '../../../../../../core/abstract/use_case.dart';
import '../../../../../../core/error/failure.dart';
import '../repositories/chat_room_repository.dart';

class ClearChatUseCase extends UseCase<bool, ClearChatParams> {
  final ChatRoomRepository _repo;

  ClearChatUseCase(this._repo);

  @override
  Future<Either<Failure, bool>> call(ClearChatParams params) {
    return _repo.clearChat(params);
  }
}

class ClearChatParams {
  final String chatId;
  final bool clearForAll;

  ClearChatParams({required this.chatId, required this.clearForAll});
}
