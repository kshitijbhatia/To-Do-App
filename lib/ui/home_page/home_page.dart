import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:todo_app/db/db_task_controller.dart';
import 'package:todo_app/models/app_theme_settings.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/models/user.dart';
import 'package:todo_app/ui/add_page/add_home_page.dart';
import 'package:todo_app/ui/common_widgets/snack_bar.dart';
import 'package:todo_app/ui/home_page/home_page_header.dart';
import 'package:todo_app/ui/home_page/home_page_tasks.dart';

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
    log('Inside function');
    final response = await TaskController.getInstance
        .getAllTasks(widget.currentUser.getEmail);
    if (response['status'] == 'success') {
      setState(() {
        _tasksList = response['data'];
      });
    } else if (response['status'] == 'error') {
      log('${response['msg']} : ${response['data']}');
      ScaffoldMessenger.of(context).showSnackBar(getCustomSnackBar('Error Fetching Notes'));
    } else if (response['status'] == 'failure') {
      ScaffoldMessenger.of(context).showSnackBar(getCustomSnackBar('No Notes Found'));
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
      setState(() {
        _tasksList.removeWhere((task) => task.getId == taskToBeDeleted.getId);
      });
      // Fix - When error occurs, the user should see the deleted item again.
    }
  }

  @override
  void initState() {
    super.initState();
    _getAllTasks();
  }

  @override
  Widget build(BuildContext context) {
    double width = ScreenSize.getWidth(context);
    double height = ScreenSize.getHeight(context);

    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    AddPageHome(currentUser: widget.currentUser),
              ),
            ).then((response) {
              if (response != null) {
                setState(() {
                  Task addedTask = response;
                  _tasksList.add(addedTask);
                });
              }
            });
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
              HomePageHeader(
                username: widget.currentUser.getUserName,
              ),
              HomePageTasks(
                  currentUser: widget.currentUser, tasksList: _tasksList, deleteTask : _deleteTask),
            ],
          ),
        ),
      ),
    );
  }
}
