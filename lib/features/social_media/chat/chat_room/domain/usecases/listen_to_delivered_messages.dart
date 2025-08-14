import '../../../../../../core/abstract/use_case.dart';
import '../repositories/chat_room_repository.dart';

class ListenToDeliveredMessagesUseCase
    extends NormalUseCase<void, Function(String chatId)> {
  final ChatRoomRepository _chatRoomRepository;

  ListenToDeliveredMessagesUseCase(this._chatRoomRepository);

  @override
  void call(Function(String chatId) params) {
    return _chatRoomRepository.listenToDeliveredStatus(params);
  }
}
