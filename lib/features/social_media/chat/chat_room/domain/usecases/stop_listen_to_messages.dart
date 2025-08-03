import '../../../../../../core/abstract/use_case.dart';
import '../repositories/chat_room_repository.dart';

class StopListenToMessagesUseCase extends NormalUseCase<void, NoParams> {
  final ChatRoomRepository _chatRoomRepository;
  StopListenToMessagesUseCase(this._chatRoomRepository);

  @override
  void call(NoParams params) {
    _chatRoomRepository.stopListenToMessages();
  }
}
