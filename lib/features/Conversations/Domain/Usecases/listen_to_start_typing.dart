import '../Repo/conversations_repo.dart';

class ListenToStartTypingUseCase {
  final ConversationsRepo conversationsRepo;

  ListenToStartTypingUseCase({required this.conversationsRepo});

  void call(Function(String) params) => conversationsRepo.listenToStartTyping(params);
}