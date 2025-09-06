import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:icons_launcher/utils/cli_logger.dart';

import '../../../../core/data/datasources/remote/api/api_consumer.dart';
import '../../../../core/data/datasources/remote/api/end_points.dart';
import '../../../../core/error/failure.dart';
import '../../../../shared_web_socket.dart';
import '../../Domain/Entities/conversation_entity.dart';
import '../../Domain/Entities/conversations_pagination.dart';
import '../Models/conversation_model.dart';

abstract class ConversationsRemoteDataSource {
  Future<Either<Failure, List<ConversationEntity>>> getSocialConversations(
      {required ConversationPagination pagination});
  void listenToUpdateSocialList(Function(ConversationEntity) params);
  Future<Either<Failure, bool>> startTyping({required String conversationId});
  void listenToStartTyping(Function(String) params);
  Future<Either<Failure, bool>> stopTyping({required String conversationId});
  void listenToStopTyping(Function(String) params);
}

class ConversationsRemoteDataSourceImpl
    implements ConversationsRemoteDataSource {
  final ApiConsumer _apiConsumer;

  ConversationsRemoteDataSourceImpl(this._apiConsumer);

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
  void listenToUpdateSocialList(Function(ConversationEntity) params) {
    try {
      // SharedWebSocket.instance.socket!.connect();

      SharedWebSocket.socket!.on('conversation:update-list', (data) {
        log("decoded data : \n$data");
        try {
          final decodedData = jsonDecode(data);
          CliLogger.info("Listen to Update Social List :  $decodedData");
          params(ConversationModel.fromJson(decodedData));
        } catch (e) {
          CliLogger.error("Listen to Update Social List Error :  $e");
        }
      });
    } catch (e) {
      CliLogger.error("Listen to Update Social List Error :  $e");
    }
  }

  @override
  Future<Either<Failure, bool>> startTyping({required String conversationId}) async {
    try {
      // serviceLocator<Socket>().connect();
      CliLogger.info('start typing  : $conversationId');

      SharedWebSocket.socket!.emit(
          'conversation:typing-started',
          jsonEncode({
            "conversationId": conversationId,
          }));
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
      SharedWebSocket.socket!.on('conversation:typing-started', (data) {
        log("decoded data : \n$data");
        try {
          final decodedData = jsonDecode(data);
          CliLogger.info("Listen to Start Typing :  $decodedData");
          params(decodedData['conversationId']);
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

      SharedWebSocket.socket!.emit(
          'conversation:typing-stopped',
          jsonEncode({
            "conversationId": conversationId,
          }));
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
      SharedWebSocket.socket!.on('conversation:user-stopped-typing', (data) {
        log("decoded data : \n$data");
        try {
          final decodedData = jsonDecode(data);
          CliLogger.info("Listen to Stop Typing :  $decodedData");
          params(decodedData['conversationId']);
        } catch (e) {
          CliLogger.error("Listen to Stop Typing Error :  $e");
        }
      });
    } catch (e) {
      CliLogger.error("Listen to Stop Typing Error :  $e");
    }
  }
}
