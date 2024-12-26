import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/repositories/chat_room_repository.dart';

class UpdateChatUseCase extends UseCase<bool, UpdateChatParams> {
  final ChatRoomRepository _repo;

  UpdateChatUseCase(this._repo);

  @override
  Future<Either<Failure, bool>> call(UpdateChatParams params) {
    return _repo.updateChat(params);
  }
}

class UpdateChatParams {
  final String chatId;
  final bool isTimerActive;

  UpdateChatParams({required this.chatId, required this.isTimerActive}); 
  }
