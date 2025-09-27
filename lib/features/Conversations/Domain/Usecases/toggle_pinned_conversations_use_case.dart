import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../Repo/conversations_repo.dart';

class TogglePinnedConversationUseCase {
  final ConversationsRepo conversationsRepository;

  TogglePinnedConversationUseCase({required this.conversationsRepository});

  Future<Either<Failure, void>> call({required String conversationId}) async {
    return await conversationsRepository.togglePinnedConversation(conversationId: conversationId);
  }
}