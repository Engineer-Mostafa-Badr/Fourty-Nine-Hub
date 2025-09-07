import 'package:fourtyninehub/features/Conversations/Domain/Repo/conversations_repo.dart';

class ListenToStopTypingUseCase {
  final ConversationsRepo conversationsRepo;

  ListenToStopTypingUseCase(this.conversationsRepo);

  void call(Function(String) params) => conversationsRepo.listenToStopTyping(params);
}