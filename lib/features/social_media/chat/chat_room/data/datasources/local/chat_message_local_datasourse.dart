import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/local_storage/local_database_consumer.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/data/models/chat_model.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/data/models/message_model.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/entities/chat_messgaes_entity.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/entities/message_entity.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/get_messages_usecase.dart';
import 'package:icons_launcher/utils/cli_logger.dart';
import 'package:sqflite/sqflite.dart';

abstract class MessagesLocalDataSource {
  Future<Either<Failure, ChatMessageEntity>> getChatMessages({
    required String chatId,
  });

  Future<Either<Failure, List<MessageEntity>>> getMessages(
      GetMessagesParams params);

  Future<Either<Failure, bool>> addMessage(MessageEntity message);

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
  Future<Either<Failure, ChatMessageEntity>> getChatMessages(
      {required String chatId}) async {
    try {
      ChatMessageEntity chatMessageEntity;
      final messages = await _database.query(DatabaseTables.messages,
          where: 'chatId = ?', whereArgs: [chatId]);
      final chat = await _database
          .query(DatabaseTables.chats, where: 'id = ?', whereArgs: [chatId]);
      chatMessageEntity = ChatMessageEntity(
          chat: ChatModel.fromDatabase(chat.first),
          messages: messages.map((e) => MessageModel.fromDatabase(e)).toList());
      return Right(chatMessageEntity);
    } catch (e) {
      CliLogger.error(e.toString());
      return const Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<MessageEntity>>> getMessages(
        GetMessagesParams params) async {
    try {
      List<MessageEntity> messages = [];
      final result = await _database.query(
        DatabaseTables.messages,
        where: 'chatId = ?',
        whereArgs: [params.chatId],
        orderBy: 'createdAt ASC',
        limit: params.pagination.limit,
        offset: params.pagination.page - 1,
      );

      for (var element in result) {
        messages.add(MessageModel.fromDatabase(element));
      }

      return Right(messages);
    } catch (e) {
      CliLogger.error(e.toString());
      return const Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> deleteMessage(
      {required String chatId, required String messageId}) async {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, bool>> addMessage(MessageEntity message) async {
    try {
      final result = await _database.insert(DatabaseTables.messages,
          MessageModel.fromEntity(message).toDatabase());
      return Right(result > 0);
    } catch (e) {
      CliLogger.error(e.toString());
      return const Left(CacheFailure());
    }
  }
}
