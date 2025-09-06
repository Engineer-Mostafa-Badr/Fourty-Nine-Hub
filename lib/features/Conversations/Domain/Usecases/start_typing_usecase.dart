import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../Repo/conversations_repo.dart';

class StartTypingUseCase {
  final ConversationsRepo repository;

  StartTypingUseCase({required this.repository});

  Future<Either<Failure, bool>> call({required String conversationId}) async {
    return await repository.startTyping(conversationId: conversationId);
  }
}