import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/api/api_consumer.dart';
import 'package:fourtyninehub/core/api/end_points.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/data/models/chat_item_model.dart';
import 'package:fourtyninehub/res/style/const.dart';

abstract class ChatsRemoteDataSource {
  Future<Either<Failure, ChatItemModel>> getChats({
    required String privacy,
    required String categoryId,
    required bool archived,
    required bool isLocked,
    required bool unRead,
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
      String? password}) async {
    var data = {
      "privacy": "normal",
      "categoryId": UIConst.chatNormalId,
      "archived": archived,
      "isLocked": isLocked,
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
}
