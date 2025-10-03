import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../Domain/Entities/conversation_entity.dart';
import '../../Domain/Entities/conversations_pagination.dart';
import '../../Domain/Repo/conversations_repo.dart';
import '../../Domain/Usecases/get_conversation_logs_use_case.dart';
import '../DataSources/conversations_remote_datasource.dart';

class ConversationsRepoImpl extends ConversationsRepo {
  final ConversationsRemoteDataSource conversationsRemoteDataSource;

  ConversationsRepoImpl({ required this.conversationsRemoteDataSource});

  @override
  Future<Either<Failure, List<ConversationEntity>>> getSocialConversations({required ConversationPagination pagination}) async {
    return await conversationsRemoteDataSource.getSocialConversations(pagination: pagination);
  }

  @override
  Future<Either<Failure, List<ConversationEntity>>> getSocialArchivedConversations({required ConversationPagination pagination}) async {
    return await conversationsRemoteDataSource.getSocialArchivedConversations(pagination: pagination);
  }

  @override
  Future<Either<Failure, List<ConversationEntity>>> getSocialGreetConversations({required ConversationPagination pagination}) async {
    return await conversationsRemoteDataSource.getSocialGreetConversations(pagination: pagination);
  }

  @override
  Future<Either<Failure, List<ConversationEntity>>> getSocialLockedConversations({required ConversationPagination pagination}) async {
    return await conversationsRemoteDataSource.getSocialLockedConversations(pagination: pagination);
  }

  @override
  Future<Either<Failure, List<ConversationEntity>>> getDeletedSocialConversations({required ConversationPagination pagination}) async {
    return await conversationsRemoteDataSource.getDeletedSocialConversations(pagination: pagination);
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

  @override
  Future<Either<Failure, void>> toggleArchivedConversation({required String conversationId}) {
    return conversationsRemoteDataSource.toggleArchivedConversation(conversationId: conversationId);
  }

  @override
  Future<Either<Failure, void>> togglePinnedConversation({required String conversationId}) {
    return conversationsRemoteDataSource.togglePinnedConversation(conversationId: conversationId);
  }

  @override
  Future<Either<Failure, void>> toggleMuteConversation({required String conversationId}) {
    return conversationsRemoteDataSource.toggleMuteConversation(conversationId: conversationId);
  }

  @override
  Future<Either<Failure, void>> deleteConversations({required List<String> conversationIds}) {
    return conversationsRemoteDataSource.deleteConversations(conversationIds: conversationIds);
  }

  @override
  Future<Either<Failure, void>> restoreConversations({required List<String> conversationIds}) {
    return conversationsRemoteDataSource.restoreConversations(conversationIds: conversationIds);
  }

  @override
  Future<Either<Failure, void>> socialLockConversations({required List<String> conversationIds}) {
    return conversationsRemoteDataSource.socialLockConversations(conversationIds: conversationIds);
  }

  @override
  Future<Either<Failure, void>> socialUnLockConversations({required List<String> conversationIds}) {
    return conversationsRemoteDataSource.socialUnLockConversations(conversationIds: conversationIds);
  }

  @override
  Future<Either<Failure, int>> getUnreadConversationsCount() {
    return conversationsRemoteDataSource.getUnreadConversationsCount();
  }

  @override
  Future<Either<Failure, List<DateTime>>> getConversationLogs({required ConversationLogsPagination pagination}) {
    return conversationsRemoteDataSource.getConversationLogs(pagination: pagination);();
  }
}