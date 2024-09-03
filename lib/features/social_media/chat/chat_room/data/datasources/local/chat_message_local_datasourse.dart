import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/api/api_consumer.dart';
import 'package:fourtyninehub/core/api/end_points.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/local_storage/local_database_consumer.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/data/models/chat_messgaes_model.dart';
import 'package:sqflite/sqflite.dart';

abstract class MessagesLocalDataSource {
  Future<Either<Failure, ChatMessagesModel>> getChatMessages({
    required String chatId,
  });

  Future<Either<Failure, bool>> deleteMessage({
    required String chatId,
    required String messageId,
  });
}

class SQFLiteMessagesLocalDataSourceImplementation
    implements MessagesLocalDataSource {
  final LocalDatabaseConsumer _database;

  SQFLiteMessagesLocalDataSourceImplementation(this._database);

  @override
  Future<Either<Failure, ChatMessagesModel>> getChatMessages(
      {required String chatId}) async {
    final response = await _database.getMessages(chatId);
    // return response.fold((failure) => Left(failure),
    //     (data) => Right(ChatMessagesModel.fromJson(data['data'])));
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, bool>> deleteMessage(
      {required String chatId, required String messageId}) async {
    var data = {
      "chatId": chatId,
      "messageId": messageId,
    };
    // final response =
    //     await _apiConsumer.delete(EndPoints.deleteChatMessage, data: data);
    // return response.fold(
    //     (failure) => Left(failure), (data) => Right(data['status']));

    throw UnimplementedError();
  }
}
