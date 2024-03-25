import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/app_theme_settings.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/models/user.dart';
import 'package:todo_app/ui/edit_page/edit_home_page.dart';

class HomePageTasks extends StatefulWidget {
  const HomePageTasks(
      {super.key,
      required this.currentUser,
      required this.tasksList,
      required this.deleteTask});

  final User currentUser;
  final List<Task> tasksList;
  final Function(Task) deleteTask;

  @override
  State<HomePageTasks> createState() => _HomePageTasksState();
}

class _HomePageTasksState extends State<HomePageTasks> {

  String _getFormattedDate(String inputDate) {
    String date = inputDate.split(' ')[0].trim();
    DateTime dateTime = DateTime.parse(date);
    String formattedDate = DateFormat.yMMMMd('en_US').format(dateTime);
    return formattedDate;
  }

  AppThemeSettings appTheme = AppThemeSettings();

  @override
  Widget build(BuildContext context) {
    double width = ScreenSize.getWidth(context);
    double height = ScreenSize.getHeight(context);

    return Expanded(
      child: ListView.builder(
        itemCount: widget.tasksList.length,
        itemBuilder: (context, index) {
          Task task = widget.tasksList[index];
          return Dismissible(
            direction: DismissDirection.endToStart,
            onDismissed: (direction) async {
              widget.deleteTask(task);
            },
            key: ValueKey<String>(task.getId),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditHomePage(
                        currentTask: task,
                        tasksList: widget.tasksList,
                      ),
                    ));
              },
              child: Container(
                width: width,
                height: height / 10,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                ),
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                    const Icon(
                      Icons.delete,
                      color: Colors.grey,
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
