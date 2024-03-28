import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/db/db_task_controller.dart';
import 'package:todo_app/constants.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/models/user.dart';
import 'package:todo_app/ui/add_page/add_page.dart';
import 'package:todo_app/ui/common_widgets/snack_bar.dart';
import 'package:todo_app/ui/home_page/home_page_tasks.dart';
import 'package:todo_app/ui/login_page/login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.currentUser});

  final User currentUser;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AppThemeSettings appTheme = AppThemeSettings();

  List<Task> _tasksList = [];

  _getAllTasks() async {
    final response = await TaskController.getInstance.getAllTasks(widget.currentUser.getEmail);
    if (response['status'] == 'success') {
      _tasksList = response['data'];
    } else if (response['status'] == 'error') {
      ScaffoldMessenger.of(context).showSnackBar(getCustomSnackBar('Error Fetching Notes'));
    }
  }

  _deleteTask(Task taskToBeDeleted) async {
    final response = await TaskController.getInstance.deleteTask(taskToBeDeleted.getId);
    if(response['status'] == 'success'){
      setState(() {
        _tasksList.removeWhere((task) => task.getId == taskToBeDeleted.getId);
      });
      ScaffoldMessenger.of(context).showSnackBar(getCustomSnackBar('Item Deleted Successfully'));
    }else if(response['status'] == 'error'){
      ScaffoldMessenger.of(context).showSnackBar(getCustomSnackBar('Error Occurred while Deleting Note'));
    }
  }

  _navigateToAddPage() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
        const AddPageHome(),
      ),
    ).then((response) {
      if (response is! String) {
        setState(() {
          Task addedTask = response;
          _tasksList.insert(0, addedTask);
        });
        ScaffoldMessenger.of(context).showSnackBar(getCustomSnackBar('Note Added Successfully'));
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
                  _HomePageHeader(
                    username: widget.currentUser.getUserName,
                  ),
                  FutureBuilder<void>(
                      future: _getAllTasks(), 
                      builder: (context, snapshot) {
                        if(snapshot.connectionState == ConnectionState.done){
                          return HomePageTasks(
                            tasksList: _tasksList,
                            deleteTask : _deleteTask,
                            navigateToAddPage: _navigateToAddPage,
                          );
                        }else{
                          return Expanded(child: Center(child: CircularProgressIndicator(color: appTheme.getPrimaryColor,),));
                        }
                      },
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
  const _HomePageHeader({super.key, required this.username});

  final String username;

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
          Text('Welcome ${widget.username}', style: const TextStyle(color: Colors.white, fontFamily: 'Roboto', fontSize: 22),),
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

