import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/data/models/message_model.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/entities/message_entity.dart';
import 'package:icons_launcher/utils/cli_logger.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
abstract class LocalDatabaseConsumer {
  Future<Either<Failure, bool>> addMessage(MessageEntity message);

  Future<Either<Failure, bool>> deleteMessage(String messageId);

  Future<Either<Failure, bool>> updateMessage(MessageEntity message);

  Future<Either<Failure, List<MessageEntity>>> getMessages(String chatId);
}

class SQFLiteDatabaseConsumer implements LocalDatabaseConsumer {
  static Database? _database;

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'fourtyninehub.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await _createMessagesTable(db, version);
      },
    );
  }

  // Singleton pattern: ensures a single instance of the database.
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<void> _createMessagesTable(Database db, int version) async {
    await db.execute('''
      CREATE TABLE ${DatabaseTables.messages}(
        id TEXT,
        text TEXT,
        chatId TEXT,
        groupId TEXT,
        seen INTEGER,
        delivered INTEGER,
        isDeleted INTEGER,
        isReply INTEGER,
        type TEXT,
        sharesCount INTEGER,
        likesCount INTEGER,
        loveCount INTEGER,
        wowCount INTEGER,
        sadCount INTEGER,
        angryCount INTEGER,
        createdAt TEXT,
        updatedAt TEXT,
        formattedCreatedAt TEXT,
        byMe INTEGER,
        replyMessageId TEXT,
        replyMessageText TEXT
      )
    ''');
  }

  @override
  Future<Either<Failure, bool>> addMessage(MessageEntity message) async {
    try {
      Database db = await database;
      final result =
          await db.insert(DatabaseTables.messages, MessageModel.fromEntity(message).toDatabase());
      if (result == 0) {
        return const Right(false);
      } else {
        return const Right(true);
      }
    } catch (e) {
      CliLogger.error(e.toString());
      return const Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> deleteMessage(String messageId) async {
    try {
      Database db = await database;
      final result = await db.delete(DatabaseTables.messages,
          where: 'id = ?', whereArgs: [messageId]);
      if (result == 0) {
        return const Right(false);
      } else {
        return const Right(true);
      }
    } catch (e) {
      CliLogger.error(e.toString());
      return const Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<MessageEntity>>> getMessages(
      String chatId) async {
    try {
      Database db = await database;
      final result = await db.query(DatabaseTables.messages,
          where: 'chatId = ?', whereArgs: [chatId]);
      return Right(result.map((e) => MessageModel.fromDatabase(e)).toList());
    } catch (e) {
      CliLogger.error(e.toString());
      return const Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> updateMessage(MessageEntity message) async {
    try {
      Database db = await database;
      final result = await db.update(DatabaseTables.messages, MessageModel.fromEntity(message).toDatabase(),
          where: 'id = ?', whereArgs: [message.id]);
      if (result == 0) {
        return const Right(false);
      } else {
        return const Right(true);
      }
    }catch(e){
      CliLogger.error(e.toString());
      return const Left(CacheFailure());
    }
  }
}

abstract class DatabaseTables {
  static const messages = 'messages';
}
