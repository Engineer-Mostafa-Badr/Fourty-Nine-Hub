import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/entities/chat_entity.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/repositories/chats_repository.dart';



class ListenToNewChatUseCase
    extends NormalUseCase<void, Function(ChatEntity)> {
  final ChatsRepository _repo;

  ListenToNewChatUseCase(this._repo);

  @override
  void call(Function(ChatEntity) params) {
    return _repo.listenToNewChats(params);
  }
}
