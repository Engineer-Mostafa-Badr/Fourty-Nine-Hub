import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/repositories/chat_room_repository.dart';

class ListenToPinMessageUseCase
    extends NormalUseCase<void, Function(ListenToPinMessageParams)> {
  final ChatRoomRepository _chatRoomRepository;

  ListenToPinMessageUseCase(this._chatRoomRepository);

  @override
  void call( Function(ListenToPinMessageParams params) params) {
    return _chatRoomRepository.listenToPinMessage(params);
  }
}

class ListenToPinMessageParams {
  String chatId;
  String messageId;
  ListenToPinMessageParams({required this.chatId, required this.messageId});
}
