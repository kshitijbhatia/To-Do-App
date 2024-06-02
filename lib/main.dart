import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/db/database.dart';
import 'package:todo_app/models/user.dart';
import 'package:todo_app/riverpod_observer.dart';
import 'package:todo_app/ui/home_page/home_page.dart';
import 'package:todo_app/ui/login_page/login_page.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError();
},);

final initializeAppFutureProvider = FutureProvider.autoDispose<Database>((ref) {
  final dbProvider = ref.watch(databaseProvider);
  return dbProvider.database;
},);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPreferences = await SharedPreferences.getInstance();
  runApp(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(sharedPreferences)
        ],
        observers: [Logger()],
        child: const MyApp(),
      ),
  );
}

class MyApp extends ConsumerStatefulWidget{
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  late String _user;
  late bool _remember;

  @override
  void initState() {
    super.initState();
    final prefs = ref.read(sharedPreferencesProvider);
    _user = prefs.getString('user') ?? '';
    _remember = prefs.getBool('remember') ?? false;

    Future.delayed(Duration.zero, () {
      if(_user.isNotEmpty){
        final userNotifier = ref.read(userStateNotifierProvider.notifier);
        final currentUser = User.fromJson(jsonDecode(_user));
        userNotifier.setUser(currentUser);
      }
    },);
  }

  @override
  Widget build(BuildContext context) {

    final body = ref.watch(initializeAppFutureProvider).when(
        data: (data) {
          return const HomePage();
        },
        error: (error, stackTrace) {
          return Text("Error Occurred : $error");
        },
        loading: () => const CircularProgressIndicator(),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: (_user.isEmpty || !_remember) ? const LoginPage() : body
    );
  }
}
