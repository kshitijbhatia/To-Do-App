import 'dart:developer';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/models/user.dart';

class DB {
  DB._privateConstructor();

  static final DB _instance = DB._privateConstructor();

  static DB get getDatabase => _instance;

  static const _databaseName = 'ToDoDB.db';
  static const _databaseVersion = 2;

  static const user_table = 'user_table';
  static const user_columnEmail = 'email';
  static const user_columnUsername = 'username';
  static const user_columnPassword = 'password';
  static const user_columncreatedAt = 'createdAt';

  static const task_table = 'task_table';
  static const task_columnId = 'id';
  static const task_columnEmail = 'email';
  static const task_columnTitle = 'title';
  static const task_columnDescription = 'description';
  static const task_columncreatedAt = 'createdAt';

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

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    String dbPath = await getDatabasesPath();
    String path = join(dbPath, _databaseName);
    log(path);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: (db, version) async {
        await db.execute(_createUserTable);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if(oldVersion == 1){
          await db.execute(_createTaskTable);
        }
      },
    );
  }

  // Register User Method

  Future<Map<String, dynamic>> registerUser(User user) async {
    try {
      int response = await _database!.insert(user_table, user.toJson());
      return {
        'status': 'success',
        'msg': 'User Created Successfully',
        'data': user
      };
    } on DatabaseException catch (err) {
      if (err.isUniqueConstraintError()) {
        return {
          'status': 'failure',
          'msg': 'Primary Key Not Unique',
          'data': err.toString()
        };
      }
      return {
        'status': 'error',
        'msg': 'Database Exception',
        'data': err.toString()
      };
    } on Error catch (err) {
      return {
        'status': 'error',
        'msg': 'Error Occurred',
        'data': err.toString()
      };
    }
  }

  // Login User Method

  Future<Map<String, dynamic>> loginUser(String email, String password) async {
    try {
      List<Map<String, dynamic>> response = await _database!.query(user_table, where: '$user_columnEmail = ?', whereArgs: ['$email']);
      if (response.isEmpty) {
        return {'status': 'failure', 'msg': 'Incorrect Email', 'data': null};
      }
      if(password != response[0]['password']){
          return {'status' : 'failure', 'msg' : 'Incorrect Password', 'data' : null};
      }
      return {'status' : 'success', 'msg' : 'User Successfully Logged In', 'data' : response[0]};
    }
    catch (err) {
      return {
        'status': 'error',
        'msg': 'Error Occurred',
        'data': err.toString()
      };
    }
  }

  // Add Task

  Future<Map<String, dynamic>> addTask(Task task) async {
    try{
      final response = await _database!.insert(task_table, task.toJson());
      log('$response');
      return {};
    }catch(err){
      log(err.toString());
      return {};
    }
  }
}
