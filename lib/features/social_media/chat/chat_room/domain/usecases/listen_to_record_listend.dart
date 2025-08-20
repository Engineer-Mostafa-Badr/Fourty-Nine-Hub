import '../../../../../../core/abstract/use_case.dart';
import '../repositories/chat_room_repository.dart';
import 'set_record_as_listened.dart';

class ListenToRecordListened
    extends NormalUseCase<void, Function(SetRecordAsListenedParams)> {
  final ChatRoomRepository _chatRoomRepository;

  ListenToRecordListened(this._chatRoomRepository);

  @override
  void call(Function(SetRecordAsListenedParams p1) params) {
    return _chatRoomRepository.listenToRecordListened(params);
  }
}
