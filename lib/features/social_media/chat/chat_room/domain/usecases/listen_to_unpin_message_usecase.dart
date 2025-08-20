import '../../../../../../core/abstract/use_case.dart';
import '../repositories/chat_room_repository.dart';

class ListenToUnPinMessageUseCase
    extends NormalUseCase<void, Function(ListenToUnPinMessageParams)> {
  final ChatRoomRepository _chatRoomRepository;

  ListenToUnPinMessageUseCase(this._chatRoomRepository);

  @override
  void call(Function(ListenToUnPinMessageParams params) params) {
    return _chatRoomRepository.listenToUnPinMessage(params);
  }
}

class ListenToUnPinMessageParams {
  String chatId;
  ListenToUnPinMessageParams({required this.chatId});
}
