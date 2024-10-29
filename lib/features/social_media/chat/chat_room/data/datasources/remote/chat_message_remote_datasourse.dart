import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/common/functions/global/upload_file.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/api_consumer.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/end_points.dart';
import 'package:fourtyninehub/core/data/datasources/remote/socket/socket_data_source.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/data/models/message_model.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/entities/message_entity.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/get_messages_usecase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/listen_to_recording_usecase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/listen_to_typing_usecase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/mark_message_as_seen_usecase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/mark_messages_as_delivered_usecase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/send_message_usecase.dart';
import 'package:icons_launcher/utils/cli_logger.dart';
import 'package:socket_io_client/socket_io_client.dart';

abstract class MessagesRemoteDataSource {
  void listenToNewMessages(Function(MessageEntity message) params);

  Future<Either<Failure, bool>> sendMessage(SendMessageParams params);

  Future<Either<Failure, bool>> startTyping({required String chatId});
   Future<Either<Failure, bool>> stopTyping({required String chatId});
   void listenToTypingStatus(Function(ListenToTypingParams listenToTypingParams) params);
   
  Future<Either<Failure, bool>> startRecording({required String chatId});
   Future<Either<Failure, bool>> stopRecording({required String chatId});
   void listenToRecordingStatus(Function(ListenToRecordingParams listenToTypingParams) params);

  Future<Either<Failure, bool>> deleteMessage({
    required String chatId,
    required String messageId,
  });

  void stopListenToMessages();

  Future<Either<Failure, List<MessageEntity>>> getMessages(
      GetMessagesParams params);

  Future<Either<Failure, bool>> markMessageAsSeen(
      MarkMessageAsSeenParams params);

  void listenToSeenStatus(Function(List<MessageEntity> messages) params);

  void stopListenToSeenStatus();

  void listenToDeliveredStatus(Function(String chatId) params);

  void stopListenToDeliveredStatus();

  Future<Either<Failure, bool>> markMessageAsDelivered(
      MarkMessagesAsDeliveredParams params);
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
        log("listenToNewMessagesssssssssssss From me");
        log("listenToNewMessagesssssssssssss  From me$decodedData");
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
        log("listenToNewMessagesssssssssssss From Other");
        log("listenToNewMessagesssssssssssss  From Other$decodedData");
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
      CliLogger.info('you send message : ${params.toString()}');
      List<String> mediaIds = [];
      for (var file in params.media) {
        final id = await UploadFile.uploadPickedFile(
            file: file, subCategoryId: params.chat.categoryId);
        if (id != null) {
          mediaIds.add(id);
        }
      }
      _socket.emit(
          SocketIOEvents.sendMessage,
          jsonEncode({
            "chatId": params.chat.id,
            "type": 1,
            "mediaIds": mediaIds,
            "text": params.message,
            "groupId": null,
            "replyMessageId": params.replyMessageId,
            "oneTimeView": params.oneTimeView,
            "sharedContacts": params.sharedContacts
                .map((contact) => contact.toJson())
                .toList(),
          }));
      return const Right(true);
    } catch (e) {
      CliLogger.error('can\'t send error $e');
      return const Left(ServerFailure(message: "can't send message "));
    }
  }

  // @override
  // Future<Either<Failure, bool>> sendMessage(SendMessageParams params) async {
  //   try {
  //     _socket.connect();
  //     CliLogger.info('You are sending message: ${params.toString()}');

  //     List<String> mediaIds = [];
  //     for (var file in params.media) {
  //       final id = await UploadFile.uploadPickedFile(
  //         file: file,
  //         subCategoryId: params.chat.categoryId,
  //       );
  //       if (id != null) {
  //         mediaIds.add(id);
  //       }
  //     }

  //     _socket.connect();
  //     _socket.emit(
  //       SocketIOEvents.sendMessage,
  //       jsonEncode({
  //         "chatId": params.chat.id,
  //         "type": 1,
  //         "mediaIds": mediaIds,
  //         "text": params.message,
  //         "groupId": null,
  //         "replyMessageId": params.replyMessageId,
  //         "oneTimeView": params.oneTimeView,
  // "sharedContacts":
  //     params.sharedContacts.map((contact) => contact.toJson()).toList(),
  //       }),
  //     );
  //     return const Right(true);
  //   } catch (e) {
  //     CliLogger.error('Can\'t send message: $e');
  //     return const Left(ServerFailure(message: "Can't send message"));
  //   }
  // }

  @override
  void stopListenToMessages() {
    _socket.off(SocketIOListeners.newMessageFromOther);
    _socket.off(SocketIOListeners.newMessageFromMe);
  }

  @override
  Future<Either<Failure, List<MessageEntity>>> getMessages(
      GetMessagesParams params) async {
    final response = await _apiConsumer.get(
        EndPoints.getChatMessages(params.chatId),
        queryParameters: params.pagination.toJson());
    return response.fold((failure) => Left(failure), (data) {
      List<MessageModel> messageModels = [];

      for (var element in data['data']) {
        messageModels.add(MessageModel.fromJson(element));
        // log(MessageModel.fromJson(element).text);
        // log(element.toString());
      }
      return Right(messageModels);
    });
  }

  @override
  Future<Either<Failure, bool>> markMessageAsSeen(
      MarkMessageAsSeenParams params) async {
    try {
      _socket.connect();
      CliLogger.info("you mark messages as seen : chatId ${params.chatId}");
      _socket.emit(
          SocketIOEvents.markMessageAsSeen,
          jsonEncode({
            "chatId": params.chatId,
          }));
      return const Right(true);
    } catch (e) {
      CliLogger.info("can't mark message as seen error $e");
      return const Left(ServerFailure(message: "can't mark message as seen"));
    }
  }

  @override
  void listenToDeliveredStatus(Function(String chatId) params) {
    try {
      _socket.connect();
      _socket.on(SocketIOListeners.messageDelivered, (data) {
        final decodedData = jsonDecode(data);
        if (decodedData is List) {
          data = decodedData[0];
        } else {
          data = decodedData;
        }
        CliLogger.info("messageDelivered :  $data");
        String chatId = data['chatId'];
        params(chatId);
      });
    } catch (e) {
      CliLogger.info("can't listen to delivered messages error $e");
    }
  }

  @override
  void listenToSeenStatus(Function(List<MessageEntity> messages) params) {
    try {
      _socket.connect();
      _socket.on(SocketIOListeners.messageSeen, (data) {
        CliLogger.info("messageSeen :  $data");
        params((jsonDecode(data) as List)
            .map((e) => MessageModel.fromJson(e))
            .toList());
      });
    } catch (e) {
      CliLogger.info("can't listen to seen messages error $e");
    }
  }

  @override
  void stopListenToDeliveredStatus() {
    _socket.off(SocketIOListeners.messageDelivered);
  }

  @override
  void stopListenToSeenStatus() {
    _socket.off(SocketIOListeners.messageSeen);
  }

  @override
  Future<Either<Failure, bool>> markMessageAsDelivered(
      MarkMessagesAsDeliveredParams params) async {
    try {
      _socket.connect();
      CliLogger.info("you mark messages as delivered");
      _socket.emit(SocketIOEvents.markMessageAsDelivered,
          jsonEncode({"chatId": params.chatId}));
      return const Right(true);
    } catch (e) {
      CliLogger.info("can't mark message as delivered error $e");
      return const Left(
          ServerFailure(message: "can't mark message as delivered"));
    }
  }

  @override
  Future<Either<Failure, bool>> startTyping({required String chatId}) async {
    try {
      _socket.connect();
      CliLogger.info('you start typing : $chatId');

      _socket.emit(
          SocketIOEvents.startTypingMessage,
          jsonEncode({
            "chatId": chatId,
          }));
      return const Right(true);
    } catch (e) {
      CliLogger.error(' can\'t start typing $e');
      return const Left(ServerFailure(message: "can't start typing"));
    }
  }

  @override
  Future<Either<Failure, bool>> stopTyping({required String chatId}) async{
    try {
      _socket.connect();
      CliLogger.info('you stop typing : $chatId');

      _socket.emit(
          SocketIOEvents.stopTypingMessage,
          jsonEncode({
            "chatId": chatId,
          }));
      return const Right(true);
    } catch (e) {
      CliLogger.error(' can\'t stop typing $e');
      return const Left(ServerFailure(message: "can't stop typing"));
    }
  }
  
  @override

  void listenToTypingStatus(Function(ListenToTypingParams listenToTypingParams) params) {
    try {
      _socket.connect();
      _socket.on(SocketIOListeners.typingMessage, (data) {
        log(data.toString());
        final decodedData = jsonDecode(data);
        log("listenToTypingStatus :  $data");
        CliLogger.info("typingChats :  $data");
        log("listenToTypingStatus decodedData:  $decodedData");
        if (decodedData is List) {
          data = decodedData[0];
        } else {
          data = decodedData;
        }
        ListenToTypingParams listenToTypingParams = ListenToTypingParams.fromJson(data);
        params(listenToTypingParams);
      });
      
    } catch (e) {
      CliLogger.info("can't listen to typing status error $e");
    }
  }
  
  @override
  void listenToRecordingStatus(Function(ListenToRecordingParams listenToRecordingParams) params) {
    try {
      _socket.connect();
      _socket.on(SocketIOListeners.recordingMessage, (data) {
        log(data.toString());
        final decodedData = jsonDecode(data);
        log("listenToRecordingStatus :  $data");
        CliLogger.info("recordingChats :  $data");
        log("listenToRecordingStatus decodedData:  $decodedData");
        if (decodedData is List) {
          data = decodedData[0];
        } else {
          data = decodedData;
        }
        ListenToRecordingParams listenToRecordingParams = ListenToRecordingParams.fromJson(data);
        params(listenToRecordingParams);
      });
      
    } catch (e) {
      CliLogger.info("can't listen to recording status error $e");
    }
  }
  
  @override
  Future<Either<Failure, bool>> startRecording({required String chatId}) async{
    try {
      _socket.connect();
      CliLogger.info('you start recording : $chatId');

      _socket.emit(
          SocketIOEvents.startRecordingMessage,
          jsonEncode({
            "chatId": chatId,
          }));
      return const Right(true);
    } catch (e) {
      CliLogger.error(' can\'t start recording $e');
      return const Left(ServerFailure(message: "can't start recording"));
    }
  }
  
  @override
  Future<Either<Failure, bool>> stopRecording({required String chatId})async {
    try {
      _socket.connect();
      CliLogger.info('you stop recording : $chatId');

      _socket.emit(
          SocketIOEvents.stopRecordingMessage,
          jsonEncode({
            "chatId": chatId,
          }));
      return const Right(true);
    } catch (e) {
      CliLogger.error(' can\'t stop recording $e');
      return const Left(ServerFailure(message: "can't stop recording"));
    }
  }
}
