import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../Repo/conversations_repo.dart';

class ToggleArchivedConversationUseCase {
  final ConversationsRepo conversationsRepository;

  ToggleArchivedConversationUseCase({required this.conversationsRepository});

  Future<Either<Failure, void>> call({required String conversationId}) async {
    return await conversationsRepository.toggleArchivedConversation(conversationId: conversationId);
  }
}