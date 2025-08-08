import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import '../../../../../../core/data/datasources/remote/api/api_consumer.dart';
import '../../../../../../core/data/datasources/remote/api/end_points.dart';
import '../../../../../../core/data/datasources/remote/socket/socket_data_source.dart';
import '../../../../../../core/error/failure.dart';
import '../../../../../authentication/data/models/user_model.dart';
import '../../../chat_room/data/models/message_model.dart';
import '../../../chat_room/data/models/seen_history_model.dart';
import '../models/chat_category_model.dart';
import '../models/chat_model.dart';
import '../../domain/entities/chat_category_entity.dart';
import '../../domain/entities/chat_entity.dart';
import '../../domain/usecases/get_chat_last_seen_usecase.dart';
import '../../domain/usecases/get_chats_usecase.dart';
import '../../domain/usecases/get_online_offline_status_usecase.dart';
import '../../domain/usecases/show_deleted_message_usecase.dart';
import '../../../../../../shared_web_socket.dart';
import 'package:icons_launcher/utils/cli_logger.dart';

abstract class ChatsRemoteDataSource {
  Future<Either<Failure, List<ChatEntity>>> getChats(GetChatsParams params);

  Future<Either<Failure, List<LastSeenChatsEntity>>> getChatLastSeen(
      String chatId);

  Future<Either<Failure, bool>> changeChatMuteState({
    required String chatId,
  });

  Future<Either<Failure, MessageModel>> showDeletedMessage(
      ShowDeletedMessageParams params);

  Future<Either<Failure, UserModel>> getUser({
    required String userId,
  });

  Future<Either<Failure, GetOnlineOfflineStatusEntity>> getOnlineOfflineStatus(
      {required String userId});

  Future<Either<Failure, bool>> changeChatToArchiveOrToNormal({
    required String chatId,
  });

  Future<Either<Failure, bool>> deleteChat({required String chatId});
  Future<Either<Failure, bool>> pinChat({required String chatId});
  Future<Either<Failure, bool>> unPinChat({required String chatId});

  Future<Either<Failure, bool>> lockChat({
    required String chatId,
    String? lockChatPassword,
  });

  Future<Either<Failure, bool>> unLockChat({
    required String chatId,
    required String password,
  });

  Future<Either<Failure, String>> updateLockChatPassword({
    required String password,
  });

  Future<Either<Failure, ChatCategoryEntity>> getGroups();
  Future<Either<Failure, bool>> recoverDeletedChats();
  Future<Either<Failure, bool>> connectMe();
  Future<Either<Failure, bool>> disconnectMe();
  Future<Either<Failure, List<SeenHistoryModel>>> getSeenHistoryList(
      {required String chatId});

  void stopListenToNewChats();

  void listenToNewChats(Function(ChatEntity) params);
}

class ChatsRemoteDataSourceImplementation implements ChatsRemoteDataSource {
  final ApiConsumer _apiConsumer;
  // final Socket _socket;

  ChatsRemoteDataSourceImplementation(this._apiConsumer);

  @override
  Future<Either<Failure, List<ChatEntity>>> getChats(
      GetChatsParams params) async {
    final response =
        await _apiConsumer.post(EndPoints.getChats, data: params.toJson());

    log("locked chats : $response");
    return response.fold(
      (failure) => Left(failure),
      (data) => Right((data['data']['chats'] as List)
          .map((e) => ChatModel.fromJson(e))
          .toList()),
    );
  }

  @override
  Future<Either<Failure, bool>> changeChatMuteState(
      {required String chatId}) async {
    final response =
        await _apiConsumer.put(EndPoints.changeChatMuteState(chatId));
    return response.fold(
        (failure) => Left(failure), (data) => Right(data['status']));
  }

  @override
  Future<Either<Failure, bool>> changeChatToArchiveOrToNormal(
      {required String chatId}) async {
    final response =
        await _apiConsumer.put(EndPoints.changeChatToArchiveOrNormal(chatId));
    return response.fold(
        (failure) => Left(failure), (data) => Right(data['status']));
  }

  @override
  Future<Either<Failure, bool>> lockChat(
      {required String chatId, String? lockChatPassword}) async {
    Map<String, dynamic>? dataParams;
    if (lockChatPassword != null) {
      dataParams = {
        'password': lockChatPassword,
      };
    }
    final response = await _apiConsumer.put(
        EndPoints.lockChat(
          chatId,
        ),
        data: dataParams);
    return response.fold(
        (failure) => Left(failure), (data) => Right(data['status']));
  }

  @override
  Future<Either<Failure, bool>> unLockChat(
      {required String chatId, required String? password}) async {
    Map<String, dynamic> data = {'password': password};
    final response =
        await _apiConsumer.put(EndPoints.unLockChat(chatId), data: data);
    return response.fold(
        (failure) => Left(failure), (data) => Right(data['status']));
  }

  @override
  Future<Either<Failure, String>> updateLockChatPassword(
      {required String password}) async {
    Map<String, dynamic>? dataParams = {
      'password': password,
    };
    final response = await _apiConsumer
        .put(EndPoints.updateUnLockChatPassword(), data: dataParams);
    return response.fold(
        (failure) => Left(failure), (data) => Right(data['status']));
  }

  @override
  Future<Either<Failure, ChatCategoryEntity>> getGroups() async {
    final response = await _apiConsumer.get(EndPoints.getChatGroups);
    return response.fold((failure) => Left(failure),
        (data) => Right(ChatCategoryModel.fromJson(data['data'])));
  }

  @override
  Future<Either<Failure, List<SeenHistoryModel>>> getSeenHistoryList(
      {required String chatId}) async {
    final response =
        await _apiConsumer.get(EndPoints.seenHistoryEndpoint(chatId));
    return response.fold(
        (failure) => Left(failure),
        (data) => Right((data['data']['lastSeen'] as List)
            .map((e) => SeenHistoryModel.fromJson(e))
            .toList()));
  }

  @override
  void listenToNewChats(Function(ChatEntity) params) {
    try {
      // SharedWebSocket.instance.socket!.connect();

      SharedWebSocket.socket!.on(SocketIOListeners.creatingNewChat, (data) {
        log("decoded data : \n$data");
        try {
          final decodedData =
              jsonDecode(data); // Decode the string into a JSON object
          CliLogger.info("new chat created :  $decodedData");
          // ChatModel chatModel = ChatModel.fromJson(decodedData);
          // log("new chat created :  $chatModel");
          // params(chatModel);
          params(ChatModel(
            id: "json['_id']",
            categoryId: "json['categoryId']",
            archived: "json['archived']" == "",
            locked: "json['locked']" == "",
            muted: "json['muted']" == "",
            name: 'Unknown',
            lastSeenCount: 0,
            unreadCount: 0,
            userId: "json['userId']",
            avatar: "json['avatar']",
            typing: false,
            online: false,
            isPinned: false,
            isService: false,
            lastMessage: null,
          ));
        } catch (e) {
          CliLogger.info("Error decoding or creating chat model: $e");
        }
      });
    } catch (e) {
      CliLogger.info("Can't read new chat error: $e");
    }
  }

  @override
  void stopListenToNewChats() {
    // TODO: implement stopListenToNewChats
  }

  @override
  Future<Either<Failure, bool>> deleteChat({required String chatId}) async {
    final response = await _apiConsumer.delete(EndPoints.deleteChat(chatId));
    return response.fold(
        (failure) => Left(failure), (data) => Right(data['status']));
  }

  @override
  Future<Either<Failure, bool>> pinChat({required String chatId}) async {
    final response = await _apiConsumer.put(EndPoints.pinAndUnPinChat(chatId));
    return response.fold(
        (failure) => Left(failure), (data) => Right(data['status']));
  }

  @override
  Future<Either<Failure, bool>> unPinChat({required String chatId}) async {
    final response = await _apiConsumer.put(EndPoints.pinAndUnPinChat(chatId));
    return response.fold(
        (failure) => Left(failure), (data) => Right(data['status']));
  }

  @override
  Future<Either<Failure, UserModel>> getUser({required String userId}) async {
    final result = await _apiConsumer.get(EndPoints.getUser(userId));
    log(result.toString(), name: "email");
    return result.fold((failure) => Left(failure), (response) {
      final user = UserModel.fromJson(
        response['data'],
      );
      return Right(user);
    });
  }

  @override
  Future<Either<Failure, MessageModel>> showDeletedMessage(
      ShowDeletedMessageParams params) async {
    var data = {
      "chatId": params.chatId,
      "messageId": params.messageId,
    };
    final response =
        await _apiConsumer.post(EndPoints.getDeletedMessage(), data: data);
    log("Show Deleted Message: $response");
    return response.fold((failure) => Left(failure), (data) {
      MessageModel messageModel = MessageModel.fromJson(data['data']);
      return Right(messageModel);
    });
  }

  @override
  Future<Either<Failure, List<LastSeenChatsEntity>>> getChatLastSeen(
      String chatId) async {
    final response = await _apiConsumer.get(EndPoints.getChatLastSeen(chatId));
    log("getChatLastSeen: $response");
    return response.fold((failure) => Left(failure), (data) {
      List<LastSeenChatsEntity> messageModel =
          (data['data']['lastSeen'] as List)
              .map((e) => LastSeenChatsEntity.fromJson(e))
              .toList();
      return Right(messageModel);
    });
  }

  @override
  Future<Either<Failure, bool>> recoverDeletedChats() async {
    final response = await _apiConsumer.put(EndPoints.recoverDeletedChats());
    log("recoverDeletedChats: $response");
    return response.fold((failure) => Left(failure), (data) {
      log("recoverDeletedChats: $data");
      return Right(data['status']);
    });
  }

  @override
  Future<Either<Failure, bool>> connectMe() async {
    try {
      CliLogger.info("connect me");
      SharedWebSocket.socket!.emit(SocketIOEvents.connectMe);
      return const Right(true);
    } catch (e) {
      CliLogger.info("connect me error $e");
      return const Left(ServerFailure(message: "connect me error"));
    }
  }

  @override
  Future<Either<Failure, bool>> disconnectMe() async {
    try {
      CliLogger.info("disconnect me");
      SharedWebSocket.socket!.emit(SocketIOEvents.disconnectMe);
      return const Right(true);
    } catch (e) {
      CliLogger.info("disconnect me error $e");
      return const Left(ServerFailure(message: "disconnect me error"));
    }
  }

  @override
  Future<Either<Failure, GetOnlineOfflineStatusEntity>> getOnlineOfflineStatus(
      {required String userId}) async {
    final response =
        await _apiConsumer.get(EndPoints.getOnlineOfflineStatus(userId));
    log("Get Online Offline Status: $response");
    return response.fold((failure) => Left(failure), (data) {
      return Right(GetOnlineOfflineStatusEntity.fromJson(data['data']));
    });
  }
}
