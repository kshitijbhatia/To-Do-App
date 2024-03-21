import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/db/database.dart';
import 'package:todo_app/ui/login_page/login_page_home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget{
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  void openDatabase() async {
    Database db = await DB.getDatabase.database;
  }

  @override
  void initState() {
    super.initState();
    openDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
