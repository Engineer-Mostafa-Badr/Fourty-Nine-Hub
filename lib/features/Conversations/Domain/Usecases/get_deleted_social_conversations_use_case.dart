import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/Conversations/Domain/Repo/conversations_repo.dart';

import '../Entities/conversation_entity.dart';
import '../Entities/conversations_pagination.dart';

class GetDeletedSocialConversationsUseCase {
  final ConversationsRepo conversationsRepo;

  GetDeletedSocialConversationsUseCase({ required this.conversationsRepo});

  Future<Either<Failure, List<ConversationEntity>>> call({required ConversationPagination pagination}) async {
    return await conversationsRepo.getDeletedSocialConversations(pagination: pagination);
  }
}