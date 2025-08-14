import 'package:dartz/dartz.dart';
import '../../../../../../core/abstract/use_case.dart';
import '../../../../../../core/error/failure.dart';
import '../repositories/chat_room_repository.dart';

class PinMessageUseCase extends UseCase<bool, PinMessageParams> {
  final ChatRoomRepository _chatRoomRepository;

  PinMessageUseCase(this._chatRoomRepository);

  @override
  Future<Either<Failure, bool>> call(PinMessageParams params) {
    return _chatRoomRepository.pinMessage(params);
  }
}

class PinMessageParams {
  final String chatId;
  final String messageId;
  PinMessageParams({required this.chatId, required this.messageId});
}
