import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/constants.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/ui/common_widgets/snack_bar.dart';
import 'package:todo_app/ui/edit_page/edit_page.dart';

class HomePageTasks extends StatefulWidget {
  const HomePageTasks(
      {super.key,
      required this.tasksList,
      required this.deleteTask,
      required this.navigateToAddPage,
      required this.navigateToEditPage
      });

  final List<Task> tasksList;
  final Function(Task) deleteTask;
  final Function() navigateToAddPage;
  final Function(Task) navigateToEditPage;

  @override
  State<HomePageTasks> createState() => _HomePageTasksState();
}

class _HomePageTasksState extends State<HomePageTasks> {
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

  @override
  Widget build(BuildContext context) {
    double width = ScreenSize.getWidth(context);
    double height = ScreenSize.getHeight(context);

    return Expanded(
      child: widget.tasksList.isEmpty
          ? GestureDetector(
              onTap: () async {
                await widget.navigateToAddPage();
              },
              child: const Center(
                child: Text('Click here to add a new note', style: TextStyle(color: Colors.black, fontSize: 20),),
              ),
            )
          : ListView.builder(
              itemCount: widget.tasksList.length,
              itemBuilder: (context, index) {
                Task task = widget.tasksList[index];
                return Dismissible(
                  direction: DismissDirection.endToStart,
                  confirmDismiss: (direction) async {
                    if(direction == DismissDirection.endToStart){
                      bool response = await _alertDialogBox();
                      return response;
                    }
                  },
                  onDismissed: (direction) async {
                    widget.deleteTask(task);
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
                                widget.deleteTask(task);
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
  }
}


