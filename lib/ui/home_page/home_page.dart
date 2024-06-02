import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/db/db_task_controller.dart';
import 'package:todo_app/constants.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/models/user.dart';
import 'package:todo_app/ui/add_page/add_page.dart';
import 'package:todo_app/ui/common_widgets/snack_bar.dart';
import 'package:todo_app/ui/edit_page/edit_page.dart';
import 'package:todo_app/ui/home_page/home_page_tasks.dart';
import 'package:todo_app/ui/login_page/login_page.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

final getTasksFutureProvider = FutureProvider.autoDispose.family<List<Task>, BuildContext>((ref, context) async {
  final taskController = ref.watch(taskProvider);
  final email = ref.watch(userStateNotifierProvider).email;
  final response = await taskController.getAllTasks(email);
  if(response['status'] == 'failure'){
    ScaffoldMessenger.of(context).showSnackBar(getCustomSnackBar('Error Fetching Notes'));
  }else{
    ref.read(taskListStateNotifierProvider.notifier).initializeList(response['data']);
  }
  return response['data'] as List<Task>;
},);

class _HomePageState extends ConsumerState<HomePage> {
  AppThemeSettings appTheme = AppThemeSettings();

  _deleteTask(Task taskToBeDeleted) async {
    final tasksListNotifier = ref.read(taskListStateNotifierProvider.notifier);
    final response = await TaskController.getInstance.deleteTask(taskToBeDeleted.getId);
    if(response['status'] == 'success'){
      log('Here');
      tasksListNotifier.removeFromList(taskToBeDeleted);
      ScaffoldMessenger.of(context).showSnackBar(getCustomSnackBar('Item Deleted Successfully'));
    }else if(response['status'] == 'error'){
      ScaffoldMessenger.of(context).showSnackBar(getCustomSnackBar('Error Occurred while Deleting Note'));
    }
  }

  _navigateToAddPage() async {
    final tasksListNotifier = ref.read(taskListStateNotifierProvider.notifier);
    await Navigator.push(context, MaterialPageRoute(builder: (context) => const AddPageHome(),),).then((response) {
      if (response is! String) {
        Task addedTask = response;
        tasksListNotifier.addToList(addedTask);
        ScaffoldMessenger.of(context).showSnackBar(getCustomSnackBar('Note Added Successfully'));
      }
    });
  }

  _navigateToEditPage(Task currentTask) async {
    final tasksListNotifier = ref.read(taskListStateNotifierProvider.notifier);
    await Navigator.push(context, MaterialPageRoute(builder: (context) => EditHomePage(currentTask: currentTask),)
    ).then((value){
      if(value is Task){
        Task updatedTask = value;
        tasksListNotifier.removeFromList(currentTask);
        tasksListNotifier.addToList(updatedTask);
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    double width = ScreenSize.getWidth(context);
    double height = ScreenSize.getHeight(context);

    return WillPopScope(
        onWillPop: () {
          return Future.value(false);
        },
        child : SafeArea(
          child: Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                await _navigateToAddPage();
              },
              backgroundColor: appTheme.getPrimaryColor,
              shape: const CircleBorder(),
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
            body: Container(
              width: width,
              height: height,
              decoration: appTheme.getBackgroundTheme,
              child: Column(
                children: [
                  const _HomePageHeader(),
                  Consumer(
                    builder : (context, ref, child) {
                      final tasksFutureProvider = ref.watch(getTasksFutureProvider(context));
                      return tasksFutureProvider.when(
                          data: (data) => HomePageTasks(
                            deleteTask: _deleteTask,
                            navigateToAddPage: _navigateToAddPage,
                            navigateToEditPage: _navigateToEditPage,
                          ),
                          error: (error, stackTrace){
                            return Container();
                          },
                          loading: () => Expanded(child: Center(child: CircularProgressIndicator(color: appTheme.getPrimaryColor,),)),
                      );
                    }
                  )
                ],
              ),
            ),
          ),
        )
    );
  }
}

class _HomePageHeader extends StatefulWidget {
  const _HomePageHeader({super.key});

  @override
  State<_HomePageHeader> createState() => _HomePageHeaderState();
}

class _HomePageHeaderState extends State<_HomePageHeader> {
  AppThemeSettings appTheme = AppThemeSettings();

  @override
  Widget build(BuildContext context) {
    double width = ScreenSize.getWidth(context);
    double height = ScreenSize.getHeight(context);

    return Container(
      decoration: appTheme.getHeaderTheme,
      height: height/14,
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Consumer(
            builder: (context, ref, child){
              final currentUser = User.fromJson(jsonDecode(ref.read(sharedPreferencesProvider).getString('user')!));
              return Text('Welcome ${currentUser.username}',
              style: const TextStyle(color: Colors.white, fontFamily: 'Roboto', fontSize: 22),
            );}
          ),
          GestureDetector(
            onTap: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setString(Constants.user, '');
              prefs.setBool(Constants.rememberUser, false);
              Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage(),));
            },
            child: const Text('LOGOUT', style: TextStyle(color: Colors.white, fontFamily: 'Roboto', fontSize: 18)),
          )
        ],
      ),
    );
  }
}

