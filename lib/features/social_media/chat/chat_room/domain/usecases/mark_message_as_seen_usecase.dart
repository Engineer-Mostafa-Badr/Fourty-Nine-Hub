import 'package:dartz/dartz.dart';
import '../../../../../../core/abstract/use_case.dart';
import '../../../../../../core/error/failure.dart';
import '../repositories/chat_room_repository.dart';

class MarkMessageAsSeenUseCase extends UseCase<bool, MarkMessageAsSeenParams> {
  final ChatRoomRepository _chatRoomRepository;

  MarkMessageAsSeenUseCase(this._chatRoomRepository);

  @override
  Future<Either<Failure, bool>> call(MarkMessageAsSeenParams params) {
    return _chatRoomRepository.markMessageAsSeen(params);
  }
}

class MarkMessageAsSeenParams {
  final String chatId;
  MarkMessageAsSeenParams({required this.chatId});
}
