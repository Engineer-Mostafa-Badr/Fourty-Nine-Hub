import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/repositories/chat_room_repository.dart';

class ListenToTypingUseCase
    extends NormalUseCase<void, Function(ListenToTypingParams)> {
  final ChatRoomRepository _chatRoomRepository;

  ListenToTypingUseCase(this._chatRoomRepository);

  @override
  void call(Function(ListenToTypingParams p1) params) {
    return _chatRoomRepository.listenToTypingStatus(params);
  }
}

class ListenToTypingParams {
  final String chatId;
  final bool isTyping;

  ListenToTypingParams.fromJson(Map<String, dynamic> json)
      : chatId = json['chatId'],
        isTyping = json['typing'];

  ListenToTypingParams({required this.chatId, required this.isTyping});
}
