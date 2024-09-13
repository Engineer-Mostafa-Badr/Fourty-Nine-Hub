import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/entities/message_entity.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/repositories/chat_room_repository.dart';

class ListenToSeenMessagesUseCase
    extends NormalUseCase<void, Function(List<MessageEntity>)> {
  final ChatRoomRepository _chatRoomRepository;

  ListenToSeenMessagesUseCase(this._chatRoomRepository);

  @override
  void call(Function(List<MessageEntity> p1) params) {
    return _chatRoomRepository.listenToSeenStatus(params);
  }
}
