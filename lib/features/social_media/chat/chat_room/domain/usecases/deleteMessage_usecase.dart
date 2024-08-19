import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/data/models/chat_messgaes_model.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/repositories/chat_room_repository.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/delete_message_request.dart';

class DeleteChatMessageUseCase extends UseCase<bool, DeleteMessageParams> {
  final ChatRoomRepository _repo;

  DeleteChatMessageUseCase(this._repo);

  @override
  Future<Either<Failure, bool>> call(DeleteMessageParams params) {
    return _repo.deleteChatMessage(params);
  }
}
