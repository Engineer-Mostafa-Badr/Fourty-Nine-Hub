import '../../../../../../core/abstract/use_case.dart';
import '../repositories/chat_room_repository.dart';
import 'delete_message_usecase.dart';

class ListenToDeleteMessageUseCase
    extends NormalUseCase<void, Function(DeleteMessageParams)> {
  final ChatRoomRepository _chatRoomRepository;

  ListenToDeleteMessageUseCase(this._chatRoomRepository);

  @override
  void call(Function(DeleteMessageParams) params) {
    return _chatRoomRepository.listenToDeleteMessage(params);
  }
}
