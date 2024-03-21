import 'dart:developer';

import 'package:sqflite/sqflite.dart';
import 'package:todo_app/db/database.dart';
import 'package:todo_app/models/user.dart';

class Authentication{
  Authentication._privateConstructor();

  static final Authentication _instance = Authentication._privateConstructor();

  static Authentication get getInstance => _instance;

  Future<Map<String, Object?>> registerUser(String email, String username, String password, String createdAt) async{
    try{
      final Database database = await DB.getDatabase.database;

      final Map<String, String> row = {
        DB.user_columnEmail : email,
        DB.user_columnUsername : username,
        DB.user_columnPassword : password,
        DB.user_columncreatedAt : createdAt
      };

      await database.insert(DB.user_table, row);

      User currentUser = User.fromJson({
        'email' : email,
        'username' : username,
        'password' : password,
        'createdAt' : createdAt
      });
      return {'status' : 'success', 'msg' : currentUser};
    }catch(err){
      return {'status' : 'error', 'msg' : null};
    }
  }

  Future<Map<String, Object?>> loginUser(String email, String password) async {
    try{
      final Database database = await DB.getDatabase.database;

      final response = await database.rawQuery('''
        SELECT * FROM ${DB.user_table} 
        WHERE ${DB.user_columnEmail} = '$email' ''');
      if(response.isEmpty){
        return {'status' : 'failure', 'msg' : 'Incorrect Email'};
      }else if(response[0]['password'] == password){
        User currentUser = User.fromJson(response[0]);
        return {'status' : 'success', 'msg' : currentUser};
      }else{
        return {'status' : 'failure', 'msg' : 'Incorrect Password'};
      }
    }catch(err){
      return {'status' : 'error', 'msg' : err.toString()};
    }
  }
}