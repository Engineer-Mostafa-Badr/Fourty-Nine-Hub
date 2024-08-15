import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/api/api_consumer.dart';
import 'package:fourtyninehub/core/api/end_points.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/data/models/chat_item_model.dart';
import 'package:fourtyninehub/res/style/const.dart';

abstract class ChatsRemoteDataSource {
  Future<Either<Failure, List<ChatItemModel>>> getChats({
    required String privacy,
    required String categoryId,
    required bool archived,
    required bool isLocked,
  });

  Future<Either<Failure, bool>> changeChatMuteState({
    required String chatId,
  });

  Future<Either<Failure, bool>> changeChatToArchiveOrToNormal({
    required String chatId,
  });
}

class ChatsRemoteDataSourceImplementation implements ChatsRemoteDataSource {
  final ApiConsumer _apiConsumer;

  ChatsRemoteDataSourceImplementation(this._apiConsumer);

  @override
  Future<Either<Failure, List<ChatItemModel>>> getChats(
      {required String privacy,
      required String categoryId,
      required bool archived,
      required bool isLocked}) async {
    var data = {
      "privacy": "normal",
      "categoryId": UIConst.chatNormalId,
      "archived": archived,
      "isLocked": isLocked
    };
    final response = await _apiConsumer.post(EndPoints.getChats, data: data);
    return response.fold(
        (failure) => Left(failure),
        (data) => Right((data['data'] as List)
            .map((e) => ChatItemModel.fromJson(e))
            .toList()));
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
}
