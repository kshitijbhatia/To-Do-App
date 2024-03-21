import 'dart:developer';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DB {
  DB._privateConstructor();

  static final DB _instance = DB._privateConstructor();

  static DB get getDatabase => _instance;

  static const _databaseName = 'ToDoDB.db';
  static const _databaseVersion = 1;

  static const user_table = 'user_table';
  static const user_columnEmail = 'email';
  static const user_columnUsername = 'username';
  static const user_columnPassword = 'password';
  static const user_columncreatedAt = 'createdAt';

  static const _createUserTable = '''
          CREATE TABLE $user_table(
            $user_columnEmail TEXT PRIMARY KEY,
            $user_columnUsername TEXT NOT NULL,
            $user_columnPassword TEXT NOT NULL,
            $user_columncreatedAt TEXT NOT NULL
          )
        ''';

  static const _createTaskTable = '''
        CREATE TABLE $task_table(
          $task_columnId INTEGER PRIMARY KEY AUTOINCREMENT,
          $task_columnTitle TEXT NOT NULL,
          $task_columnDescription TEXT NOT NULL,
          $task_columnEmail TEXT NOT NULL,
          $task_columncreatedAt TEXT NOT NULL,
          FOREIGN KEY ($task_columnEmail) REFERENCES $user_table($user_columnEmail)
        )
      ''';

  static const task_table = 'task_table';
  static const task_columnId = 'id';
  static const task_columnEmail = 'email';
  static const task_columnTitle = 'title';
  static const task_columnDescription = 'description';
  static const task_columncreatedAt = 'createdAt';

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    String dbPath = await getDatabasesPath();
    String path = join(dbPath, _databaseName);
    log("Connected to DB!!");
    return await openDatabase(
      path,
      version: _databaseVersion,
onDowngrade: ,
      onUpgrade: ,
      onCreate: (db, version) async {
        await db.execute(_createUserTable);
        await db.execute(_createTaskTable);
      },
    );
  }
}
