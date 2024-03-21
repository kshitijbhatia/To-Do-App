import 'package:todo_app/models/task.dart';

class TaskController{
  TaskController._privateConstructor();

  static final TaskController _instance = TaskController._privateConstructor();

  static TaskController get getInstance => _instance;

  Future<Map<String, dynamic>> addTask(Task task) async{
    return {};
  }
}