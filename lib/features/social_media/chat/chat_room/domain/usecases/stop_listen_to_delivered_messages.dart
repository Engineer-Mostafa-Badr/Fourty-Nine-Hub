import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/repositories/chat_room_repository.dart';

class StopListenToDeliveredMessagesUseCase
    extends NormalUseCase<void, NoParams> {
  final ChatRoomRepository _chatRoomRepository;

  StopListenToDeliveredMessagesUseCase(this._chatRoomRepository);

  @override
  void call(NoParams params) {
    return _chatRoomRepository.stopListenToDeliveredStatus();
  }
}
