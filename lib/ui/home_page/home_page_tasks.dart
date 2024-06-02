import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/constants.dart';
import 'package:todo_app/db/db_task_controller.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/ui/common_widgets/snack_bar.dart';

class HomePageTasks extends ConsumerStatefulWidget {
  const HomePageTasks(
      {super.key,
      required this.deleteTask,
      required this.navigateToAddPage,
      required this.navigateToEditPage
      });

  final Function(Task) deleteTask;
  final Function() navigateToAddPage;
  final Function(Task) navigateToEditPage;

  @override
  ConsumerState<HomePageTasks> createState() => _HomePageTasksState();
}

class _HomePageTasksState extends ConsumerState<HomePageTasks> {

  String _getFormattedDate(String inputDate) {
    String timeResult = DateFormat('jm').format(DateTime.parse(inputDate));
    String formattedDate = DateFormat.yMMMd('en_US').format(DateTime.parse(inputDate));
    return '$timeResult, $formattedDate';
  }

  AppThemeSettings appTheme = AppThemeSettings();

  Future<bool> _alertDialogBox() async {
    bool? response =  await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext _alertDialogContext) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
          title: const Text('Delete Note?'),
          content: const Text('Are you sure you want to delete this note?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(_alertDialogContext).pop(true);
              },
              style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(appTheme.getPrimaryColor),
                foregroundColor: const MaterialStatePropertyAll(Colors.white)
              ),
              child: const Text('Yes',),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(_alertDialogContext).pop(false);
              },
              child: const Text('No'),
            ),
          ],
        );
      },
    );
    return response!;
  }

  _deleteTask(Task taskToBeDeleted) async {
    final tasksListNotifier = ref.read(taskListStateNotifierProvider.notifier);
    final taskController = ref.read(taskProvider);
    final response = await taskController.deleteTask(taskToBeDeleted.getId);
    if(response['status'] == 'success'){
      tasksListNotifier.removeFromList(taskToBeDeleted);
      ScaffoldMessenger.of(context).showSnackBar(getCustomSnackBar('Item Deleted Successfully'));
    }else if(response['status'] == 'error'){
      ScaffoldMessenger.of(context).showSnackBar(getCustomSnackBar('Error Occurred while Deleting Note'));
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = ScreenSize.getWidth(context);
    double height = ScreenSize.getHeight(context);

    return Consumer(
        builder: (context, ref, child) {
          final tasksList = ref.watch(taskListStateNotifierProvider);
          return Expanded(
            child: tasksList.isEmpty
                ? GestureDetector(
              onTap: () async {
                await widget.navigateToAddPage();
              },
              child: const Center(
                child: Text('Click here to add a new note', style: TextStyle(color: Colors.black, fontSize: 20),),
              ),
            )
                : ListView.builder(
              itemCount: tasksList.length,
              itemBuilder: (context, index) {
                Task task = tasksList[index];
                return Dismissible(
                  direction: DismissDirection.endToStart,
                  confirmDismiss: (direction) async {
                    if(direction == DismissDirection.endToStart){
                      bool response = await _alertDialogBox();
                      return response;
                    }
                  },
                  onDismissed: (direction) async {
                    _deleteTask(task);
                  },
                  key: UniqueKey(),
                  child: GestureDetector(
                    onTap: () {
                      widget.navigateToEditPage(task);
                    },
                    child: Container(
                      width: width,
                      height: height / 10,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                task.getTitle,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Roboto',
                                  fontSize: 25,
                                ),
                              ),
                              Text(_getFormattedDate(task.getCreatedAt))
                            ],
                          ),
                          IconButton(
                            onPressed: () async {
                              bool response = await _alertDialogBox();
                              if(response){
                                _deleteTask(task);
                              }
                            },
                            icon: const Icon(Icons.delete),
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
    );
  }
}


