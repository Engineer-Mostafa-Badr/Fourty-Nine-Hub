import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/api_consumer.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/end_points.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/data/models/chat_messgaes_model.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/data/models/message_model.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/entities/message_entity.dart';
import 'package:icons_launcher/utils/cli_logger.dart';
import 'package:socket_io_client/socket_io_client.dart';

abstract class MessagesRemoteDataSource {
  Future<Either<Failure, ChatMessagesModel>> getChatMessages({
    required String chatId,
  });

  StreamController<Either<Failure, MessageEntity>> listenToNewMessages(
      {required String chatId});

  Future<Either<Failure, bool>> deleteMessage({
    required String chatId,
    required String messageId,
  });
}

class MessagesRemoteDataSourceImplementation
    implements MessagesRemoteDataSource {
  final ApiConsumer _apiConsumer;
  // final Socket _socket;

  MessagesRemoteDataSourceImplementation(this._apiConsumer);

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
  StreamController<Either<Failure, MessageEntity>> listenToNewMessages(
      {required String chatId}) {
    StreamController<Either<Failure, MessageEntity>> _messagesStream =
        StreamController<Either<Failure, MessageEntity>>();

    // try {
    //   _socket.on('user:message', (data) {
    //     CliLogger.info("user:message $data");
    //     MessageModel messageModel = MessageModel.fromJson(data);
    //     _messagesStream.add(Right(messageModel));
    //     CliLogger.info("socketMessageModel ${messageModel.text}");
    //   });
    // } catch (e) {
    //   CliLogger.info("error $e");
    //   _messagesStream.add(Left(UnknownFailure('error')));
    // }
    return _messagesStream;
  }
}
