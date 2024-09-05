import 'dart:async';
import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/api_consumer.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/end_points.dart';
import 'package:fourtyninehub/core/data/datasources/remote/socket/socket_data_source.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/data/models/chat_messgaes_model.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/data/models/message_model.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/entities/message_entity.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/send_message_usecase.dart';
import 'package:icons_launcher/utils/cli_logger.dart';
import 'package:socket_io_client/socket_io_client.dart';

abstract class MessagesRemoteDataSource {
  Future<Either<Failure, ChatMessagesModel>> getChatMessages({
    required String chatId,
  });

  void listenToNewMessages(Function(MessageEntity) params);

  Future<Either<Failure, bool>> sendMessage(SendMessageParams params);

  Future<Either<Failure, bool>> deleteMessage({
    required String chatId,
    required String messageId,
  });

  void stopListenToNewMessages() ;
}

class MessagesRemoteDataSourceImplementation
    implements MessagesRemoteDataSource {
  final ApiConsumer _apiConsumer;
  final Socket _socket;

  MessagesRemoteDataSourceImplementation(this._apiConsumer, this._socket);

  @override
  Future<Either<Failure, ChatMessagesModel>> getChatMessages(
      {required String chatId}) async {
    final response = await _apiConsumer.get(EndPoints.getChatMessages(chatId));
    return response.fold((failure) => Left(failure),
        (data) => Right(ChatMessagesModel.fromJson(data['data'])));
  }

  @override
  Future<Either<Failure, bool>> deleteMessage(
      {required String chatId, required String messageId}) async {
    var data = {
      "chatId": chatId,
      "messageId": messageId,
    };
    final response =
        await _apiConsumer.delete(EndPoints.deleteChatMessage, data: data);
    return response.fold(
        (failure) => Left(failure), (data) => Right(data['status']));
  }

  @override
  void listenToNewMessages(Function(MessageEntity) params) {
    try {
      _socket.on(SocketIOEvents.newMessageFromMe, (data) {
        
        CliLogger.info("newMessageFromMe :  $data");
        MessageModel messageModel = MessageModel.fromJson(jsonDecode(data));
        params(messageModel);
      });
      _socket.on(SocketIOEvents.newMessageFromOther, (data) {
        CliLogger.info("newMessageFromOther :  $data");
        MessageModel messageModel = MessageModel.fromJson(jsonDecode(data));
        params(messageModel);
      });
    } catch (e) {
      CliLogger.info("can't read last message error $e");
    }
  }

  @override
  Future<Either<Failure, bool>> sendMessage(SendMessageParams params) async{
    try{
      _socket.emit(SocketIOMessages.sendMessage,params.toSocketParams());
      CliLogger.info('message sent successfully');
      return const Right(true);
    }catch(e){
      CliLogger.error('can\'t send error $e');
      return const Left(ServerFailure(message: "can't send message "));
    }
  }

  @override
  void stopListenToNewMessages() {
    // _socket.off(SocketIOEvents.newMessage);
  }
}
