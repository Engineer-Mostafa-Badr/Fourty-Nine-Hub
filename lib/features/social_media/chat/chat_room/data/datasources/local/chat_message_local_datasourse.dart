import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/data/datasources/local/database/local_database_data_source.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/entities/message_entity.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/get_messages_usecase.dart';
import 'package:icons_launcher/utils/cli_logger.dart';
import 'package:sqflite/sqflite.dart';

abstract class MessagesLocalDataSource {
  Future<Either<Failure, List<MessageEntity>>> getMessages(
      GetMessagesParams params);

  Future<Either<Failure, bool>> saveMessage(MessageEntity message);

  Future<Either<Failure, bool>> deleteMessage({
    required String chatId,
    required String messageId,
  });
}

class SQFLiteMessagesLocalDataSourceImplementation
    implements MessagesLocalDataSource {
  final Database _database;

  SQFLiteMessagesLocalDataSourceImplementation(this._database);

  @override
  Future<Either<Failure, List<MessageEntity>>> getMessages(
      GetMessagesParams params) async {
    try {
      List<MessageEntity> messages = [];
      final result = await _database.query(
        DatabaseTables.messages,
        where: 'chatId = ?',
        whereArgs: [params.chatId],
        // orderBy: 'createdAt DESC',
        // limit: params.pagination.limit,
        // offset: (params.pagination.page - 1) * params.pagination.limit,
      );

      for (var element in result) {
        // messages.add(MessageModel.fromDatabase(element));
      }

      return Right(messages);
    } catch (e) {
      CliLogger.error("error while get messages from database ${e.toString()}");
      return const Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> deleteMessage(
      {required String chatId, required String messageId}) async {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, bool>> saveMessage(MessageEntity message) async {
    try {
      // final result = await _database.insert(DatabaseTables.messages,
      //     MessageModel.fromEntity(message).toDatabase());
      // return Right(result > 0);
      return const Right(false);
    } catch (e) {
      CliLogger.error("error while saving message to database ${e.toString()}");
      return const Left(CacheFailure());
    }
  }
}
