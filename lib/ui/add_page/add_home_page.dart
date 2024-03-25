import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:todo_app/db/db_task_controller.dart';
import 'package:todo_app/app_theme_settings.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/models/user.dart';
import 'package:todo_app/ui/common_widgets/add_edit_reg_header.dart';
import 'package:todo_app/ui/common_widgets/submit_button.dart';
import 'package:todo_app/ui/common_widgets/text_input.dart';
import 'package:uuid/uuid.dart';

class AddPageHome extends StatefulWidget {
  const AddPageHome({super.key, required this.currentUser});

  final User currentUser;

  @override
  State<AddPageHome> createState() => _AddPageHomeState();
}

class _AddPageHomeState extends State<AddPageHome> {
  AppThemeSettings appTheme = AppThemeSettings();
  late TextEditingController titleController;
  late TextEditingController descController;

  String? titleError;
  String? descriptionError;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController();
    descController = TextEditingController();
  }

  final snackbar = const SnackBar(
    content: Text('Cannot Add Note', style: TextStyle(color: Colors.white, fontSize: 18),),
    duration: Duration(seconds: 2),
    backgroundColor: Color.fromRGBO(70, 98, 224, 1),
  );

  AddTask() async {
    if (titleController.text == '' || descController.text == '') {
      setState(() {
        titleError =
            titleController.text == '' ? 'Please enter the title' : null;
        descriptionError =
            descController.text == '' ? 'Please enter the description' : null;
      });
      return;
    }

    var uuid = const Uuid();

    Task task = Task(
      id: uuid.v4(),
      email: widget.currentUser.getEmail,
      title: titleController.text,
      description: descController.text,
      createdAt: DateTime.now().toString(),
    );

    TaskController taskcontroller = TaskController.getInstance;

    final response = await taskcontroller.addTask(task);

    if(response['status'] == 'error' ){
      log('${response['msg']} : ${response['data']}');
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }else if(response['status'] == 'success'){
      Navigator.pop(context, task);
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
              const Header(text: 'Add Note'),
              TextInput(
                text: 'Title',
                icon: Icons.text_fields,
                inputType: TextInputType.text,
                controller: titleController,
                error: titleError,
                removeError: () {},
              ),
              TextInput(
                text: 'Description',
                icon: Icons.text_snippet,
                inputType: TextInputType.text,
                controller: descController,
                error: descriptionError,
                removeError: () {},
              ),
              SubmitButton(text: 'SAVE', onClicked: AddTask)
            ],
          ),
        ),
      ),
    );
  }
}
