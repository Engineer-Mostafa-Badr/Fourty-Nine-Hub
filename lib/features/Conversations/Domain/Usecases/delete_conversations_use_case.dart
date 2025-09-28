
import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../Repo/conversations_repo.dart';

class DeleteConversationsUseCase {
  final ConversationsRepo conversationsRepository;

  DeleteConversationsUseCase({required this.conversationsRepository});

  Future<Either<Failure, void>> call({required List<String> conversationIds}) async {
    return await conversationsRepository.deleteConversations(conversationIds: conversationIds);
  }
}