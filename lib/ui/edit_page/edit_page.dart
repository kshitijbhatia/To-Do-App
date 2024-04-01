import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:todo_app/db/db_task_controller.dart';
import 'package:todo_app/constants.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/ui/common_widgets/header.dart';
import 'package:todo_app/ui/common_widgets/snack_bar.dart';
import 'package:todo_app/ui/common_widgets/submit_button.dart';
import 'package:todo_app/ui/common_widgets/text_input.dart';

class EditHomePage extends StatefulWidget {
  const EditHomePage({super.key, required this.currentTask, required this.tasksList});

  final Task currentTask;
  final List<Task> tasksList;

  @override
  State<EditHomePage> createState() => _EditHomePageState();
}

class _EditHomePageState extends State<EditHomePage> {
  AppThemeSettings appTheme = AppThemeSettings();

  late TextEditingController _titleController;
  late TextEditingController _desController;

  String? _titleError;
  String? _descriptionError;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.currentTask.getTitle);
    _desController =
        TextEditingController(text: widget.currentTask.getDescription);
  }

  updateTask() async {
    Task updatedTask = Task(id: widget.currentTask.getId,
        email: widget.currentTask.getEmail,
        title: _titleController.text.trim(),
        description: _desController.text.trim(),
        createdAt: DateTime.now().toString(),
    );

    final response = await TaskController.getInstance.updateTask(updatedTask);

    if(response['status'] == 'success'){
      Navigator.pop(context, updatedTask);
    }else if(response['status'] == 'error'){
      ScaffoldMessenger.of(context).showSnackBar(getCustomSnackBar('Cannot Update Note'));
    }
  }

  final _formKey = GlobalKey<FormState>();

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
            key: _formKey,
            child: Column(
              children: [
                const Header(text: 'Edit Note'),
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
                  controller: _desController,
                  error: _descriptionError,
                  removeError: () {
                    setState(() {
                      _descriptionError = null;
                    });
                  },
                  isType: "description",
                  maxLength: 200,
                ),
                SubmitButton(text: 'UPDATE', onClicked: updateTask, formKey: _formKey,)
              ],
            ),
          )
        ),
      ),
    );
  }
}
