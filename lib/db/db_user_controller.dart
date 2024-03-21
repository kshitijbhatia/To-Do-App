import 'dart:developer';

import 'package:sqflite/sqflite.dart';
import 'package:todo_app/db/database.dart';
import 'package:todo_app/models/user.dart';

class UserController{
  UserController._privateConstructor();

  static final UserController _instance = UserController._privateConstructor();

  static UserController get getInstance => _instance;

  Future<Map<String, dynamic>> registerUser(User user) async{
      final db = DB.getDatabase;
      Map<String, dynamic> response = await db.registerUser(user);
      return response;
  }

  Future<Map<String, dynamic>> loginUser(String email, String password) async {
    try{
      final db = DB.getDatabase;
      Map<String, dynamic> response = await db.loginUser(email, password);
      if(response['status'] == 'success'){
        response['data'] = User.fromJson(response['data']);
      }
      return response;
    }catch(err){
      return {'status' : 'error', 'msg' : 'Error Parsing Json', 'data' : null};
    }
  }
}