import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/repositories/chat_room_repository.dart';

class PinMessageUseCase extends UseCase<bool, PinMessageParams> {
  final ChatRoomRepository _chatRoomRepository;

  PinMessageUseCase(this._chatRoomRepository);

  @override
  Future<Either<Failure, bool>> call(PinMessageParams params) {
    return _chatRoomRepository.pinMessage(params);
  }
}

class PinMessageParams  {
  final String chatId;
  final String messageId;
  PinMessageParams({required this.chatId, required this.messageId});
}
