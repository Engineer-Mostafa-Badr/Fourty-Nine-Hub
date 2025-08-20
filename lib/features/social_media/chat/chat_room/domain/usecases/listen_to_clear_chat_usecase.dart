import '../../../../../../core/abstract/use_case.dart';
import '../repositories/chat_room_repository.dart';

class ListenToClearChatUseCase
    extends NormalUseCase<void, Function(String chatId)> {
  final ChatRoomRepository _chatRoomRepository;

  ListenToClearChatUseCase(this._chatRoomRepository);

  @override
  void call(Function(String chatId) params) {
    return _chatRoomRepository.listenToClearChatStatus(params);
  }
}
