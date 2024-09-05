import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/api_consumer.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/end_points.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/data/models/seen_history_model.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/data/models/chat_item_model.dart';
import 'package:fourtyninehub/res/style/const.dart';

abstract class ChatsRemoteDataSource {
  Future<Either<Failure, ChatItemModel>> getChats({
    required String privacy,
    required String categoryId,
    required bool archived,
    required bool isLocked,
    required bool unRead,
    required bool isServices,
    String? password,
  });

  Future<Either<Failure, bool>> changeChatMuteState({
    required String chatId,
  });

  Future<Either<Failure, bool>> changeChatToArchiveOrToNormal({
    required String chatId,
  });

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

  Future<Either<Failure, ChatItemModel>> getGroups();

  Future<Either<Failure, List<SeenHistoryModel>>> getSeenHistoryList(
      {required String chatId});
}

class ChatsRemoteDataSourceImplementation implements ChatsRemoteDataSource {
  final ApiConsumer _apiConsumer;

  ChatsRemoteDataSourceImplementation(this._apiConsumer);

  @override
  Future<Either<Failure, ChatItemModel>> getChats(
      {required String privacy,
      required String categoryId,
      required bool archived,
      required bool isLocked,
      required bool unRead,
      required bool isServices,
      String? password}) async {
    var data = {
      "privacy": "normal",
      "categoryId": categoryId,
      "archived": archived,
      "isLocked": isLocked,
      "isServices": isServices,
      "isUnread": unRead,
      if (password != null) "password": password
    };
    final response = await _apiConsumer.post(EndPoints.getChats, data: data);
    return response.fold(
      (failure) => Left(failure),
      (data) => Right(ChatItemModel.fromJson(data['data'])),
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
  Future<Either<Failure, ChatItemModel>> getGroups() async {
    final response = await _apiConsumer.get(EndPoints.getChatGroups);
    return response.fold((failure) => Left(failure),
        (data) => Right(ChatItemModel.fromJson(data['data'])));
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
}
