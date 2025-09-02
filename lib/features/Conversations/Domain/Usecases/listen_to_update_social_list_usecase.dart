import 'package:fourtyninehub/features/Conversations/Domain/Entities/conversation_entity.dart';

import '../Repo/conversations_repo.dart';

class ListenToUpdateSocialListUseCase {
  final ConversationsRepo conversationsRepository;

  ListenToUpdateSocialListUseCase({required this.conversationsRepository});

  void call(Function(ConversationEntity) params) {
    return conversationsRepository.listenToUpdateSocialList(params);
  }
}