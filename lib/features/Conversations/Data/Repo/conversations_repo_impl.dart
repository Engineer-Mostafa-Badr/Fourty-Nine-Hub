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

  @override
  void listenToUpdateSocialList(Function(ConversationEntity) params) {
    return conversationsRemoteDataSource.listenToUpdateSocialList(params);
  }

  @override
  Future<Either<Failure, bool>> startTyping({required String conversationId}){
    return conversationsRemoteDataSource.startTyping(conversationId: conversationId);
  }

  @override
  void listenToStartTyping(Function(String) params) {
    return conversationsRemoteDataSource.listenToStartTyping(params);
  }

  @override
  Future<Either<Failure, bool>> stopTyping({required String conversationId}){
    return conversationsRemoteDataSource.stopTyping(conversationId: conversationId);
  }

  @override
  void listenToStopTyping(Function(String) params) {
    return conversationsRemoteDataSource.listenToStopTyping(params);
  }
}