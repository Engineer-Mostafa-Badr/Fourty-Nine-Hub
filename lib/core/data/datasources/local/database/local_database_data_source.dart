import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SQFLiteDataSource {
  SQFLiteDataSource._privateConstructor();

  static final SQFLiteDataSource instance = SQFLiteDataSource._privateConstructor();

  static Database? _database;

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

