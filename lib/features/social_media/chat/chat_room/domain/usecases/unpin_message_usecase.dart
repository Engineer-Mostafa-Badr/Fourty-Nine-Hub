import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/repositories/chat_room_repository.dart';

class UnPinMessageUseCase extends UseCase<bool, UnPinMessageParams> {
  final ChatRoomRepository _chatRoomRepository;

  UnPinMessageUseCase(this._chatRoomRepository);

  @override
  Future<Either<Failure, bool>> call(UnPinMessageParams params) {
    return _chatRoomRepository.unPinMessage(params);
  }
}

class UnPinMessageParams {
  final String chatId;
  UnPinMessageParams({required this.chatId});
}
