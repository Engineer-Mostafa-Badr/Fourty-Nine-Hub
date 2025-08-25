import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../Domain/Entities/conversation_entity.dart';
import '../../Domain/Entities/conversations_pagination.dart';
import '../../Domain/Repo/conversations_repo.dart';
import '../DataSources/conversations_remote_datasource.dart';

class ConversationsRepoImpl extends ConversationsRepo {
  final ConversationsRemoteDataSource conversationsRemoteDataSource;

  ConversationsRepoImpl({ required this.conversationsRemoteDataSource});

  @override
  Future<Either<Failure, List<ConversationEntity>>> getSocialConversations({required ConversationPagination pagination}) async {
    return await conversationsRemoteDataSource.getSocialConversations(pagination: pagination);
  }
}