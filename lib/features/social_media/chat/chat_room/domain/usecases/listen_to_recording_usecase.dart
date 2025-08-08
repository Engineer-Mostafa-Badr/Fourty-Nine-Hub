import '../../../../../../core/abstract/use_case.dart';
import '../repositories/chat_room_repository.dart';

class ListenToRecordingUseCase
    extends NormalUseCase<void, Function(ListenToRecordingParams)> {
  final ChatRoomRepository _chatRoomRepository;

  ListenToRecordingUseCase(this._chatRoomRepository);

  @override
  void call(Function(ListenToRecordingParams p1) params) {
    return _chatRoomRepository.listenToRecordingStatus(params);
  }
}

class ListenToRecordingParams {
  final String chatId;
  final bool isRecording;

  ListenToRecordingParams.fromJson(Map<String, dynamic> json)
      : chatId = json['chatId'],
        isRecording = json['recording'];

  ListenToRecordingParams({required this.chatId, required this.isRecording});
}
