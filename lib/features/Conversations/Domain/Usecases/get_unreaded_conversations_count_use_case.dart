
import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../Repo/conversations_repo.dart';

class GetUnreadConversationsUseCase {
  final ConversationsRepo conversationsRepository;

  GetUnreadConversationsUseCase({required this.conversationsRepository});

  Future<Either<Failure, int>> call() async {
    return await conversationsRepository.getUnreadConversationsCount();
  }
}