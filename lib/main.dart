import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/db/database.dart';
import 'package:todo_app/models/user.dart';
import 'package:todo_app/ui/home_page/home_page.dart';
import 'package:todo_app/ui/login_page/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget{
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _user = '';
  bool _remember = false;

  void _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _user = prefs.getString('user') ?? '';
      _remember = prefs.getBool('remember') ?? false;
    });
    log('$_user $_remember');
  }

  Future<void> _openDatabase() async {
    await DB.getDatabase.database;
  }

  @override
  void initState() {
    super.initState();
    _openDatabase();
    _loadPreferences();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: (_user == '' || !_remember)
          ? const LoginPage()
          : FutureBuilder<void>(
              future: _openDatabase(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return HomePage(
                    currentUser: User.fromJson(jsonDecode(_user)),
                  );
                } else{
                  return const CircularProgressIndicator();
                }
              },
            ),
      debugShowCheckedModeBanner: false,
    );
  }
}
