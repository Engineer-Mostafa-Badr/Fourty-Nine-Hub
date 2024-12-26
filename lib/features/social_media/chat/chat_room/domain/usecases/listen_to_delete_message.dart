import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/repositories/chat_room_repository.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/delete_message_usecase.dart';

import '../entities/message_entity.dart';

class ListenToDeleteMessageUseCase
    extends NormalUseCase<void, Function(DeleteMessageParams)> {
  final ChatRoomRepository _chatRoomRepository;

  ListenToDeleteMessageUseCase(this._chatRoomRepository);

  @override
  void call(Function(DeleteMessageParams) params) {
    return _chatRoomRepository.listenToDeleteMessage(params);
  }
}
