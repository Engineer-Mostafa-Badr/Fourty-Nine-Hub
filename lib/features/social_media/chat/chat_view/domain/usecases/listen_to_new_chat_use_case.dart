import '../../../../../../core/abstract/use_case.dart';
import '../entities/chat_entity.dart';
import '../repositories/chats_repository.dart';

class ListenToNewChatUseCase extends NormalUseCase<void, Function(ChatEntity)> {
  final ChatsRepository _repo;

  ListenToNewChatUseCase(this._repo);

  @override
  void call(Function(ChatEntity) params) {
    return _repo.listenToNewChats(params);
  }
}
