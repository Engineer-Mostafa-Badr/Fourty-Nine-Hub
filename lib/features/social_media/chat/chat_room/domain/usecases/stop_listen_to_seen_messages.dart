import '../../../../../../core/abstract/use_case.dart';
import '../repositories/chat_room_repository.dart';

class StopListenToSeenMessagesUseCase extends NormalUseCase<void, NoParams> {
  final ChatRoomRepository _chatRoomRepository;

  StopListenToSeenMessagesUseCase(this._chatRoomRepository);

  @override
  void call(NoParams params) {
    return _chatRoomRepository.stopListenToSeenStatus();
  }
}
