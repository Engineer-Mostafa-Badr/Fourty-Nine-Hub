import 'package:dartz/dartz.dart';
import '../../../../../../core/abstract/use_case.dart';
import '../../../../../../core/error/failure.dart';
import '../repositories/chat_room_repository.dart';

class MarkMessagesAsDeliveredUseCase
    extends UseCase<void, MarkMessagesAsDeliveredParams> {
  final ChatRoomRepository _chatRoomRepository;

  MarkMessagesAsDeliveredUseCase(this._chatRoomRepository);

  @override
  Future<Either<Failure, void>> call(MarkMessagesAsDeliveredParams params) {
    return _chatRoomRepository.markMessageAsDelivered(params);
  }
}

class MarkMessagesAsDeliveredParams {
  String chatId;

  MarkMessagesAsDeliveredParams({required this.chatId});
}
