import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/repositories/chat_room_repository.dart';

import '../entities/message_entity.dart';

class ListenToNewMessageUseCase
    extends NormalUseCase<Stream<MessageEntity>, NoParams> {
  final ChatRoomRepository _chatRoomRepository;

  ListenToNewMessageUseCase(this._chatRoomRepository);

  @override
  Stream<MessageEntity> call(NoParams params) {
    return _chatRoomRepository.listenToNewMessages();
  }
}
