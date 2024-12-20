import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/repositories/chat_room_repository.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/set_record_as_listened.dart';

class ListenToRecordListened
    extends NormalUseCase<void, Function(SetRecordAsListenedParams)> {
  final ChatRoomRepository _chatRoomRepository;

  ListenToRecordListened(this._chatRoomRepository);

  @override
  void call(Function(SetRecordAsListenedParams p1) params) {
    return _chatRoomRepository.listenToRecordListened(params);
  }
}
