import 'package:dartz/dartz.dart';
import '../../../../../../core/abstract/use_case.dart';
import '../../../../../../core/error/failure.dart';
import '../repositories/chat_room_repository.dart';

class DeleteMessageUseCase extends UseCase<bool, DeleteMessageParams> {
  final ChatRoomRepository _repo;

  DeleteMessageUseCase(this._repo);

  @override
  Future<Either<Failure, bool>> call(DeleteMessageParams params) {
    return _repo.deleteMessage(params);
  }
}

class DeleteMessageParams {
  final String chatId;
  final String messageId;

  DeleteMessageParams({required this.chatId, required this.messageId});
}
