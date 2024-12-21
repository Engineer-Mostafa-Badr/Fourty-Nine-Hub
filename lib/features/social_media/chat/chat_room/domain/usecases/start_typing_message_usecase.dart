import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/repositories/chat_room_repository.dart';

class StartTypingMessageUseCase extends UseCase<bool, String> {
  final ChatRoomRepository _chatRoomRepository;

  StartTypingMessageUseCase(this._chatRoomRepository);

  @override
  Future<Either<Failure, bool>> call(String params) async {
    return _chatRoomRepository.startTyping(chatId: params);
  }
}
