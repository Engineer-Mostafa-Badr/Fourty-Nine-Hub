import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/Conversations/Domain/Repo/conversations_repo.dart';


class GetConversationLogsUseCase {
  final ConversationsRepo conversationsRepo;

  GetConversationLogsUseCase({ required this.conversationsRepo});

  Future<Either<Failure, List<DateTime>>> call({required ConversationLogsPagination pagination}) async {
    return await conversationsRepo.getConversationLogs(pagination: pagination);
  }
}

class ConversationLogsPagination {
  final int page;
  final int limit;
  final String conversationId;

  ConversationLogsPagination({required this.page, required this.limit, required this.conversationId});
}