import 'dart:async';
import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/api_consumer.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/end_points.dart';
import 'package:fourtyninehub/core/data/datasources/remote/socket/socket_data_source.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/data/models/message_model.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/entities/message_entity.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/send_message_usecase.dart';
import 'package:icons_launcher/utils/cli_logger.dart';
import 'package:socket_io_client/socket_io_client.dart';

abstract class MessagesRemoteDataSource {
  void listenToNewMessages(Function(MessageEntity message) params);

  Future<Either<Failure, bool>> sendMessage(SendMessageParams params);

  Future<Either<Failure, bool>> deleteMessage({
    required String chatId,
    required String messageId,
  });

  void stopListenToMessages();
}

class MessagesRemoteDataSourceImplementation
    implements MessagesRemoteDataSource {
  final ApiConsumer _apiConsumer;
  final Socket _socket;

  MessagesRemoteDataSourceImplementation(this._apiConsumer, this._socket);

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
  void listenToNewMessages(Function(MessageEntity message) params) {
    try {
      _socket.connect();
      _socket.on(SocketIOListeners.newMessageFromMe, (data) {
        final decodedData = jsonDecode(data);
        if (decodedData is List) {
          data = decodedData[0];
        } else {
          data = decodedData;
        }
        CliLogger.info("newMessageFromMe :  $data");
        MessageModel messageModel = MessageModel.fromJson(data);
        params(messageModel);
      });
      _socket.on(SocketIOListeners.newMessageFromOther, (data) {
        final decodedData = jsonDecode(data);
        if (decodedData is List) {
          data = decodedData[0];
        } else {
          data = decodedData;
        }
        CliLogger.info("newMessageFromOther :  $data");
        MessageModel messageModel = MessageModel.fromJson(data);
        params(messageModel);
      });
    } catch (e) {
      CliLogger.info("can't read last message error $e");
    }
  }

  @override
  Future<Either<Failure, bool>> sendMessage(SendMessageParams params) async {
    try {
      _socket.connect();
      CliLogger.info('you send message : ${params.toSocketParams()}');
      _socket.emit(SocketIOEvents.sendMessage, params.toSocketParams());
      return const Right(true);
    } catch (e) {
      CliLogger.error('can\'t send error $e');
      return const Left(ServerFailure(message: "can't send message "));
    }
  }

  @override
  void stopListenToMessages() {
    _socket.off(SocketIOListeners.newMessageFromOther);
    _socket.off(SocketIOListeners.newMessageFromMe);
  }
}
