import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/db/database.dart';
import 'package:todo_app/models/task.dart';

final taskProvider = Provider((ref) {
  return TaskController.getInstance;
},);

class TaskController{
  TaskController._privateConstructor();
  static final TaskController _instance = TaskController._privateConstructor();

  static TaskController get getInstance => _instance;

  final _database = DB.getDatabase;

  Future<Map<String, dynamic>> getAllTasks(String email) async {
    try{
      Map<String, dynamic> response = await _database.getAllTasks(email);
      if(response['status'] == 'success') {
        List<Task> tasks = [];
        List<Map<String, dynamic>> resList = response['data'];
        tasks.addAll(resList.map((task) => Task.fromJson(task)).toList());
        tasks.sort((a,b){
          DateTime aDateTime = DateTime.parse(a.getCreatedAt);
          DateTime bDateTime = DateTime.parse(b.getCreatedAt);
          return bDateTime.millisecondsSinceEpoch.compareTo(aDateTime.millisecondsSinceEpoch);
        });
        response['data'] = tasks;
      }
      return response;
    }catch(err){
      return {'status' : 'error', 'msg' : 'Error Parsing Json', 'data' : null};
    }
  }

  Future<Map<String, dynamic>> addTask(Task task) async{
    final response = await _database.addTask(task);
    return response;
  }

  Future<Map<String, dynamic>> deleteTask(String id) async {
    final response = await _database.deleteTask(id);
    return response;
  }

  Future<Map<String, dynamic>> updateTask(Task task) async {
    final response = await _database.updateTask(task);
    return response;
  }
}