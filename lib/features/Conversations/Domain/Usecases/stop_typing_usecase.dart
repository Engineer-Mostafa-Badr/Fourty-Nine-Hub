import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../Repo/conversations_repo.dart';

class StopTypingUseCase {
  final ConversationsRepo conversationsRepository;

  StopTypingUseCase({required this.conversationsRepository});

  Future<Either<Failure, bool>> call({required String conversationId}) async {
    return await conversationsRepository.stopTyping(conversationId: conversationId);
  }
}