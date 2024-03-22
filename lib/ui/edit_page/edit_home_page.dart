import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:todo_app/db/db_task_controller.dart';
import 'package:todo_app/models/app_theme_settings.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/ui/common_widgets/add_edit_reg_header.dart';
import 'package:todo_app/ui/common_widgets/submit_button.dart';
import 'package:todo_app/ui/common_widgets/text_input.dart';

class EditHomePage extends StatefulWidget {
  const EditHomePage(
      {super.key, required this.currentTask, required this.tasksList});

  final Task currentTask;
  final List<Task> tasksList;

  @override
  State<EditHomePage> createState() => _EditHomePageState();
}

class _EditHomePageState extends State<EditHomePage> {
  AppThemeSettings appTheme = AppThemeSettings();

  late TextEditingController titleController;
  late TextEditingController desController;

  String? titleError;
  String? descriptionError;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.currentTask.getTitle);
    desController =
        TextEditingController(text: widget.currentTask.getDescription);
  }

  final snackbar = const SnackBar(
    content: Text('Cannot Update Note', style: TextStyle(color: Colors.white, fontSize: 18),),
    duration: Duration(seconds: 2),
    backgroundColor: Color.fromRGBO(70, 98, 224, 1),
  );

  updateTask() async {
    if (titleController.text == '' || desController.text == '') {
      setState(() {
        titleError =
        titleController.text == '' ? 'Please enter the title' : null;
        descriptionError =
        desController.text == '' ? 'Please enter the description' : null;
      });
      return;
    }

    Task updatedTask = Task(id: widget.currentTask.getId,
        email: widget.currentTask.getEmail,
        title: titleController.text,
        description: desController.text,
        createdAt: DateTime.now().toString(),
    );

    final response = await TaskController.getInstance.updateTask(updatedTask);

    if(response['status'] == 'success'){
      setState(() {
        widget.tasksList.removeWhere((task) => task.getId == widget.currentTask.getId);
        widget.tasksList.add(updatedTask);
      });
      Navigator.pop(context);
    }else if(response['status'] == 'error'){
      log('${response['msg']} : ${response['data']}');
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = ScreenSize.getWidth(context);
    double height = ScreenSize.getHeight(context);

    return SafeArea(
      child: Scaffold(
        body: Container(
          width: width,
          height: height,
          decoration: appTheme.getBackgroundTheme,
          child: Column(
            children: [
              const Header(text: 'Edit Note'),
              TextInput(
                text: 'Title',
                icon: Icons.text_fields,
                inputType: TextInputType.text,
                controller: titleController,
                error: titleError,
                removeError: () {
                  setState(() {
                    titleError = null;
                  });
                },
              ),
              TextInput(
                text: 'Description',
                icon: Icons.text_snippet,
                inputType: TextInputType.text,
                controller: desController,
                error: descriptionError,
                removeError: () {
                  setState(() {
                    descriptionError = null;
                  });
                },
              ),
              SubmitButton(text: 'UPDATE', onClicked: updateTask)
            ],
          ),
        ),
      ),
    );
  }
}
