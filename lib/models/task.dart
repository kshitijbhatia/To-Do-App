import 'package:flutter_riverpod/flutter_riverpod.dart';

class Task {
  String _id;
  String _email;
  String _title;
  String _description;
  String _createdAt;
  String? _updatedAt;

  Task({
      required String id,
      required String email,
      required String title,
      required String description,
      required String createdAt})
      : _id = id,
        _email = email,
        _title = title,
        _description = description,
        _createdAt = createdAt;

  String get getId => _id;

  String get getEmail => _email;

  String get getTitle => _title;

  String get getDescription => _description;

  String get getCreatedAt => _createdAt;

  Task copyWith({String? id, String? email, String? title, String? description}){
    return Task(
        id: id ?? _id,
        email: email ?? _email,
        title: title ?? _title,
        description: description ?? _title,
        createdAt: _createdAt
    );
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      email: json['email'],
      title: json['title'],
      description: json['description'],
      createdAt: json['createdAt'],
    );
  }

  Map<String, dynamic> toJson(){
    return {
      "id" : _id,
      "email" : _email,
      "title" : _title,
      "description" : _description,
      "createdAt" : _createdAt,
    };
  }
}

class TaskListStateNotifier extends StateNotifier<List<Task>>{
  TaskListStateNotifier() : super([]);

  initializeList(List<Task> tasksList){
    state = tasksList;
  }

  addToList(Task task){
    state = [task, ...state];
  }

  removeFromList(Task taskToBeDeleted) {
    state = removeElement(state, taskToBeDeleted);
  }
}

final taskListStateNotifierProvider = StateNotifierProvider<TaskListStateNotifier, List<Task>>((ref) {
  return TaskListStateNotifier();
},);

List<Task> removeElement(List<Task> list, Task taskToBeDeleted){
  return list.where((task) => task._id != taskToBeDeleted._id,).toList();
}