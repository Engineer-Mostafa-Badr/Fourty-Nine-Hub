import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/data/models/chat_model.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/data/models/message_model.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/entities/chat_entity.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/entities/message_entity.dart';
import 'package:icons_launcher/utils/cli_logger.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SQFLiteHelper {
  SQFLiteHelper._privateConstructor();

  static final SQFLiteHelper instance = SQFLiteHelper._privateConstructor();

  static Database? _database;

  // Singleton pattern: ensures a single instance of the database.
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'fourtyninehub.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await _createMessagesTable(db, version);
        await _createChatsTable(db, version);
      },
    );
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

  Future<void> _createChatsTable(Database db, int version) async {
    await db.execute('''
      CREATE TABLE ${DatabaseTables.chats}(
        id TEXT,
        contactId TEXT,
        contactAvatar TEXT,
        contactName TEXT,
        privacy TEXT,
        type TEXT,
        categoryId TEXT,
        createdAt TEXT,
        updatedAt TEXT,
        lastMessage TEXT
      )
    ''');
  }
}

abstract class DatabaseTables {
  static const messages = 'messages';
  static const chats = 'chats';
}
