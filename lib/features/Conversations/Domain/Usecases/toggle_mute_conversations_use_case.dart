import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../Repo/conversations_repo.dart';

class ToggleMuteConversationUseCase {
  final ConversationsRepo conversationsRepository;

  ToggleMuteConversationUseCase({required this.conversationsRepository});

  Future<Either<Failure, void>> call({required String conversationId}) async {
    return await conversationsRepository.toggleMuteConversation(conversationId: conversationId);
  }
}