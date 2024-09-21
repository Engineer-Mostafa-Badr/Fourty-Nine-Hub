import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/repositories/chat_room_repository.dart';

class StopListenToNewMessage extends NormalUseCase<void, NoParams> {
  final ChatRoomRepository _chatRoomRepository;

  StopListenToNewMessage(this._chatRoomRepository);

  @override
  void call(NoParams params) {
    // TODO: implement call
  }
}
