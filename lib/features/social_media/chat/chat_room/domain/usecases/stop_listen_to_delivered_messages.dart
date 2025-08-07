import '../../../../../../core/abstract/use_case.dart';
import '../repositories/chat_room_repository.dart';

class StopListenToDeliveredMessagesUseCase
    extends NormalUseCase<void, NoParams> {
  final ChatRoomRepository _chatRoomRepository;

  StopListenToDeliveredMessagesUseCase(this._chatRoomRepository);

  @override
  void call(NoParams params) {
    return _chatRoomRepository.stopListenToDeliveredStatus();
  }
}
