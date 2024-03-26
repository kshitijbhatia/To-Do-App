import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:todo_app/db/db_task_controller.dart';
import 'package:todo_app/constants.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/models/user.dart';
import 'package:todo_app/ui/common_widgets/header.dart';
import 'package:todo_app/ui/common_widgets/snack_bar.dart';
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
  late TextEditingController _titleController;
  late TextEditingController _descController;

  String? _titleError;
  String? _descriptionError;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descController = TextEditingController();
  }

  _addTask() async {
    var uuid = const Uuid();

    Task task = Task(
      id: uuid.v4(),
      email: widget.currentUser.getEmail,
      title: _titleController.text.trim(),
      description: _descController.text.trim(),
      createdAt: DateTime.now().toString(),
    );

    TaskController taskcontroller = TaskController.getInstance;

    final response = await taskcontroller.addTask(task);

    if(response['status'] == 'error' ){
      ScaffoldMessenger.of(context).showSnackBar(getCustomSnackBar('Cannot Add Note'));
    }else if(response['status'] == 'success'){
      Navigator.pop(context, task);
    }
  }

  final formKey = GlobalKey<FormState>();

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
          child: Form(
            key: formKey,
            child: Column(
              children: [
                const Header(text: 'Add Note'),
                TextInput(
                  text: 'Title',
                  icon: Icons.text_fields,
                  inputType: TextInputType.text,
                  controller: _titleController,
                  error: _titleError,
                  removeError: () {
                    setState(() {
                      _titleError = null;
                    });
                  },
                  isType: "title",
                  maxLength: 20,
                ),
                TextInput(
                  text: 'Description',
                  icon: Icons.text_snippet,
                  inputType: TextInputType.text,
                  controller: _descController,
                  error: _descriptionError,
                  removeError: () {
                    setState(() {
                      _descriptionError = null;
                    });
                  },
                  isType: "description",
                  maxLength: 200,
                ),
                SubmitButton(text: 'SAVE', onClicked: _addTask, formKey: formKey,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
