import '../../../../../../core/abstract/use_case.dart';
import '../repositories/chat_room_repository.dart';

import '../entities/message_entity.dart';

class ListenToNewMessageUseCase
    extends NormalUseCase<void, Function(MessageEntity)> {
  final ChatRoomRepository _chatRoomRepository;

  ListenToNewMessageUseCase(this._chatRoomRepository);

  @override
  void call(Function(MessageEntity) params) {
    return _chatRoomRepository.listenToNewMessages(params);
  }
}
