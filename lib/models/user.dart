import 'package:flutter_riverpod/flutter_riverpod.dart';

class User{
  final String username;
  final String email;
  final String password;
  final String createdAt;
  final String? updatedAt;

  User({
    required this.username,
    required this.email,
    required this.password,
    required this.createdAt,
    this.updatedAt
  });


  String get getEmail => email;

  String get getUserName => username;

  String get getCreatedAt => createdAt;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        email: json['email'],
        username: json['username'],
        password: json['password'],
        createdAt: json['createdAt']
    );
  }

  Map<String, String> toJson(){
    return {
      "email" : email,
      "username" : username,
      "password" : password,
      "createdAt" : createdAt
    };
  }
}

class UserNotifier extends StateNotifier<User>{
  UserNotifier(User initialUser) : super(initialUser);

  setUser(User user){
    state = user;
  }
}

final userStateNotifierProvider = StateNotifierProvider<UserNotifier, User>((ref) {
  return UserNotifier(User(
    email: '',
    username: '',
    password: '',
    createdAt: '',
    updatedAt: ''
  ));
},);