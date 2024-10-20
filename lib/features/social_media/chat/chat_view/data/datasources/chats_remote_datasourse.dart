import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/api_consumer.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/end_points.dart';
import 'package:fourtyninehub/core/data/datasources/remote/socket/socket_data_source.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/data/models/seen_history_model.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/data/models/chat_category_model.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/data/models/chat_model.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/entities/chat_category_entity.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/entities/chat_entity.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/usecases/create_anonymous_chat_use_case.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/usecases/create_normal_chat_use_case.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/usecases/get_chats_usecase.dart';
import 'package:icons_launcher/utils/cli_logger.dart';
import 'package:socket_io_client/socket_io_client.dart';

abstract class ChatsRemoteDataSource {
  Future<Either<Failure, List<ChatEntity>>> getChats(GetChatsParams params);

  Future<Either<Failure, bool>> changeChatMuteState({
    required String chatId,
  });

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

  Future<Either<Failure, List<SeenHistoryModel>>> getSeenHistoryList(
      {required String chatId});

  Future<Either<Failure, bool>> createNormalChat(CreateNormalChatParams params);

  Future<Either<Failure, bool>> createAnonymousChat(
      CreateAnonymousChatParams params);

  void stopListenToNewChats();

  void listenToNewChats(Function(ChatEntity) params);
}

class ChatsRemoteDataSourceImplementation implements ChatsRemoteDataSource {
  final ApiConsumer _apiConsumer;
  final Socket _socket;

  ChatsRemoteDataSourceImplementation(this._apiConsumer, this._socket);

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
  Future<Either<Failure, bool>> createNormalChat(
      CreateNormalChatParams params) async {
    final response = await _apiConsumer.post(EndPoints.createNormalChat(
      categoryId: params.categoryId,
      otherUserId: params.otherUserId,
    ));
    return response.fold(
        (failure) => Left(failure), (data) => Right(data['status']));
  }

  @override
  Future<Either<Failure, bool>> createAnonymousChat(
      CreateAnonymousChatParams params) async {
    final response = await _apiConsumer
        .post(EndPoints.createAnonymousChat(params.otherUserId));

    return response.fold(
        (failure) => Left(failure), (data) => Right(data['status']));
  }

  @override
  void listenToNewChats(Function(ChatEntity) params) {
    try {
      _socket.connect();

      _socket.on(SocketIOListeners.creatingNewChat, (data) {
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

  Future<Either<Failure, bool>> pinChat({required String chatId}) async {
    final response = await _apiConsumer.put(EndPoints.pinAndUnPinChat(chatId));
    return response.fold(
        (failure) => Left(failure), (data) => Right(data['status']));
  }

  Future<Either<Failure, bool>> unPinChat({required String chatId}) async {
    final response = await _apiConsumer.put(EndPoints.pinAndUnPinChat(chatId));
    return response.fold(
        (failure) => Left(failure), (data) => Right(data['status']));
  }
}
