import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:icons_launcher/utils/cli_logger.dart';

import '../../../../core/data/datasources/remote/api/api_consumer.dart';
import '../../../../core/data/datasources/remote/api/end_points.dart';
import '../../../../core/error/failure.dart';
import '../../../../shared_web_socket.dart';
import '../../Domain/Entities/conversation_entity.dart';
import '../../Domain/Entities/conversations_pagination.dart';
import '../../Domain/Usecases/get_conversation_logs_use_case.dart';
import '../Models/conversation_model.dart';

abstract class ConversationsRemoteDataSource {
  Future<Either<Failure, List<ConversationEntity>>> getSocialConversations(
      {required ConversationPagination pagination});
  Future<Either<Failure, List<ConversationEntity>>> getSocialArchivedConversations(
      {required ConversationPagination pagination});
  Future<Either<Failure, List<ConversationEntity>>> getSocialGreetConversations(
      {required ConversationPagination pagination});
  Future<Either<Failure, List<ConversationEntity>>> getSocialAnonymousConversations(
      {required ConversationPagination pagination});
  Future<Either<Failure, List<ConversationEntity>>> getSocialLockedConversations(
      {required ConversationPagination pagination});
  Future<Either<Failure, List<ConversationEntity>>> getDeletedSocialConversations(
      {required ConversationPagination pagination});
  void listenToUpdateSocialList(Function(ConversationEntity) params);
  Future<Either<Failure, bool>> startTyping({required String conversationId});
  void listenToStartTyping(Function(String) params);
  Future<Either<Failure, bool>> stopTyping({required String conversationId});
  void listenToStopTyping(Function(String) params);
  Future<Either<Failure, void>> toggleArchivedConversation({required String conversationId});
  Future<Either<Failure, void>> togglePinnedConversation({required String conversationId});
  Future<Either<Failure, void>> toggleMuteConversation({required String conversationId});
  Future<Either<Failure, void>> deleteConversations({required List<String> conversationIds});
  Future<Either<Failure, void>> restoreConversations({required List<String> conversationIds});
  Future<Either<Failure, void>> socialLockConversations({required List<String> conversationIds});
  Future<Either<Failure, void>> socialUnLockConversations({required List<String> conversationIds});
  Future<Either<Failure, int>> getUnreadConversationsCount();
  Future<Either<Failure, List<DateTime>>> getConversationLogs({required ConversationLogsPagination pagination});
}

class ConversationsRemoteDataSourceImpl
    implements ConversationsRemoteDataSource {
  final ApiConsumer _apiConsumer;

  ConversationsRemoteDataSourceImpl(this._apiConsumer);

  @override
  Future<Either<Failure, List<DateTime>>> getConversationLogs({required ConversationLogsPagination pagination}) async {
    final response = await _apiConsumer.get(EndPoints.getConversationLogs(
        page: pagination.page, limit: pagination.limit, conversationId: pagination.conversationId));
    return response.fold(
        (failure) => Left(failure),
        (data) => Right((data['data']['logs'] as List)
            .map((e) => DateTime.parse(e['openedAt'] ?? DateTime.now()))
            .toList()));
  }

  @override
  Future<Either<Failure, List<ConversationEntity>>> getSocialConversations(
      {required ConversationPagination pagination}) async {
    final response = await _apiConsumer.get(EndPoints.getSocialConversations(
        page: pagination.page, limit: pagination.limit));
    return response.fold(
        (failure) => Left(failure),
        (data) => Right((data['data']['conversations'] as List)
            .map((e) => ConversationModel.fromJson(e))
            .toList()));
  }

  @override
  Future<Either<Failure, List<ConversationEntity>>> getSocialArchivedConversations(
      {required ConversationPagination pagination}) async {
    final response = await _apiConsumer.get(EndPoints.getSocialArchivedConversations(
        page: pagination.page, limit: pagination.limit));
    return response.fold(
        (failure) => Left(failure),
        (data) => Right((data['data']['conversations'] as List)
            .map((e) => ConversationModel.fromJson(e))
            .toList()));
  }

  @override
  Future<Either<Failure, List<ConversationEntity>>> getSocialGreetConversations(
      {required ConversationPagination pagination}) async {
    final response = await _apiConsumer.get(EndPoints.getSocialGreetConversations(
        page: pagination.page, limit: pagination.limit));
    return response.fold(
        (failure) => Left(failure),
        (data) => Right((data['data']['conversations'] as List)
            .map((e) => ConversationModel.fromJson(e))
            .toList()));
  }

  @override
  Future<Either<Failure, List<ConversationEntity>>> getSocialLockedConversations(
      {required ConversationPagination pagination}) async {
    final response = await _apiConsumer.get(EndPoints.getSocialLockedConversations(
        page: pagination.page, limit: pagination.limit));
    return response.fold(
        (failure) => Left(failure),
        (data) => Right((data['data']['conversations'] as List)
            .map((e) => ConversationModel.fromJson(e))
            .toList()));
  }

  @override
  Future<Either<Failure, List<ConversationEntity>>> getSocialAnonymousConversations(
      {required ConversationPagination pagination}) async {
    final response = await _apiConsumer.get(EndPoints.getSocialAnonymousConversations(
        page: pagination.page, limit: pagination.limit));
    return response.fold(
        (failure) => Left(failure),
        (data) => Right((data['data']['conversations'] as List)
            .map((e) => ConversationModel.fromJson(e))
            .toList()));
  }

  @override
  Future<Either<Failure, List<ConversationEntity>>> getDeletedSocialConversations(
      {required ConversationPagination pagination}) async {
    final response = await _apiConsumer.get(EndPoints.getDeletedSocialConversations(
        page: pagination.page, limit: pagination.limit));
    return response.fold(
        (failure) => Left(failure),
        (data) => Right((data['data']['conversations'] as List)
            .map((e) => ConversationModel.fromJson(e))
            .toList()));
  }

  @override
  void listenToUpdateSocialList(Function(ConversationEntity) params) {
    try {
      // SharedWebSocket.instance.socket!.connect();

      SharedWebSocket.socket?.on('conversation:update-list', (data) {
        log("decoded data : \n$data");
        try {
          // final decodedData = jsonDecode(data);
          CliLogger.info("Listen to Update Social List :  $data");
          params(ConversationModel.fromJson(data));
        } catch (e) {
          CliLogger.error("Listen to Update Social List Error 1 :  $e");
        }
      });
    } catch (e) {
      CliLogger.error("Listen to Update Social List Error 2:  $e");
    }
  }

  @override
  Future<Either<Failure, bool>> startTyping({required String conversationId}) async {
    try {
      // serviceLocator<Socket>().connect();
      CliLogger.info('start typing  : $conversationId');

      SharedWebSocket.socket?.emit(
          'conversation:typing-started',
           conversationId,
          );
      return const Right(true);
    } catch (e) {
      CliLogger.error(' can\'t start typing $e');
      return const Left(ServerFailure(message: "can't start typing"));
    }
  }

  @override
  void listenToStartTyping(Function(String) params) {
    try {
      // serviceLocator<Socket>().connect();
      SharedWebSocket.socket?.on('conversation:user-typing', (data) {
        log("decoded data : \n$data");
        try {
          // final decodedData = jsonDecode(data);
          CliLogger.info("Listen to Start Typing :  $data");
          // Listen to Start Typing :  {conversationId: 6891db829fd423658d5c72ff}
          params(data['conversationId']);
        } catch (e) {
          CliLogger.error("Listen to Start Typing Error :  $e");
        }
      });
    } catch (e) {
      CliLogger.error("Listen to Start Typing Error :  $e");
    }
  }

  @override
  Future<Either<Failure, bool>> stopTyping({required String conversationId}) async {
    try {
      // serviceLocator<Socket>().connect();
      CliLogger.info('stop typing  : $conversationId');

      SharedWebSocket.socket?.emit(
          'conversation:typing-stopped',
             conversationId,
          );
      return const Right(true);
    } catch (e) {
      CliLogger.error(' can\'t stop typing $e');
      return const Left(ServerFailure(message: "can't stop typing"));
    }
  }

  @override
  void listenToStopTyping(Function(String) params) {
    try {
      // serviceLocator<Socket>().connect();
      SharedWebSocket.socket?.on('conversation:user-stopped-typing', (data) {
        log("decoded data : \n$data");
        try {
          // final decodedData = jsonDecode(data);
          CliLogger.info("Listen to Stop Typing :  $data");
          // Listen to Stop Typing :  {conversationId: 6891db829fd423658d5c72ff}
          params(data['conversationId']);
        } catch (e) {
          CliLogger.error("Listen to Stop Typing Error :  $e");
        }
      });
    } catch (e) {
      CliLogger.error("Listen to Stop Typing Error :  $e");
    }
  }

  @override
  Future<Either<Failure, void>> toggleArchivedConversation({required String conversationId}) async {
    final response = await _apiConsumer.put(EndPoints.toggleArchiveConversation(conversationId: conversationId));
    return response.fold(
            (failure) => Left(failure),
            (data) => Right(null));
  }

  @override
  Future<Either<Failure, void>> togglePinnedConversation({required String conversationId}) async {
    final response = await _apiConsumer.put(EndPoints.togglePinnedConversation(conversationId: conversationId));
    return response.fold(
            (failure) => Left(failure),
            (data) => Right(null));
  }

  @override
  Future<Either<Failure, void>> toggleMuteConversation({required String conversationId}) async {
    final response = await _apiConsumer.put(EndPoints.toggleMuteConversation(conversationId: conversationId));
    return response.fold(
            (failure) => Left(failure),
            (data) => Right(null));
  }

  @override
  Future<Either<Failure, void>> deleteConversations({required List<String> conversationIds}) async {
    final response = await _apiConsumer.delete(EndPoints.deleteConversations, data: {"conversationIds": conversationIds});
    return response.fold(
            (failure) => Left(failure),
            (data) => Right(null));
  }

  @override
  Future<Either<Failure, void>> restoreConversations({required List<String> conversationIds}) async {
    final response = await _apiConsumer.put(EndPoints.restoreConversations, data: {"conversationIds": conversationIds});
    return response.fold(
            (failure) => Left(failure),
            (data) => Right(null));
  }

  @override
  Future<Either<Failure, void>> socialLockConversations({required List<String> conversationIds}) async {
    final response = await _apiConsumer.put(EndPoints.socialLockConversations,
        data: {"conversationIds": conversationIds});
    return response.fold(
            (failure) => Left(failure),
            (data) => Right(null));
  }

  @override
  Future<Either<Failure, void>> socialUnLockConversations({required List<String> conversationIds}) async {
    final response = await _apiConsumer.put(EndPoints.socialUnLockConversations, data: {"conversationIds": conversationIds});
    return response.fold(
            (failure) => Left(failure),
            (data) => Right(null));
  }

  @override
  Future<Either<Failure, int>> getUnreadConversationsCount() async {
    final response = await _apiConsumer.get(EndPoints.unreadCount);
    return response.fold(
            (failure) => Left(failure),
            (data) => Right(data['data']?['unreadConversationsCount'] ?? 0));
  }
}
