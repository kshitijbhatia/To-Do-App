import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/db/db_task_controller.dart';
import 'package:todo_app/constants.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/models/form_data.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/models/user.dart';
import 'package:todo_app/ui/common_widgets/header.dart';
import 'package:todo_app/ui/common_widgets/snack_bar.dart';
import 'package:todo_app/ui/common_widgets/submit_button.dart';
import 'package:todo_app/ui/common_widgets/text_input.dart';
import 'package:uuid/uuid.dart';

class AddPageHome extends ConsumerStatefulWidget {
  const AddPageHome({super.key});

  @override
  ConsumerState<AddPageHome> createState() => _AddPageHomeState();
}

class _AddPageHomeState extends ConsumerState<AddPageHome> {
  AppThemeSettings appTheme = AppThemeSettings();
  late TextEditingController _titleController;
  late TextEditingController _descController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descController = TextEditingController();
  }

  _addTask() async {
    final user = ref.read(userStateNotifierProvider);
    var uuid = const Uuid();

    Task task = Task(
      id: uuid.v4(),
      email: user.getEmail,
      title: _titleController.text.trim(),
      description: _descController.text.trim(),
      createdAt: DateTime.now().toString(),
    );

    final taskController = ref.read(taskProvider);
    final response = await taskController.addTask(task);

    if(response['status'] == 'error' ){
      ScaffoldMessenger.of(context).showSnackBar(getCustomSnackBar('Cannot Add Note'));
    }else if(response['status'] == 'success'){
      ref.read(titleStateNotifierProvider.notifier).updateError(null);
      ref.read(descriptionNotifierProvider.notifier).updateError(null);
      Navigator.pop(context, task);
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
            child: Consumer(
              builder : (context, ref, child) {
                final titleField = ref.watch(titleStateNotifierProvider);
                final descriptionField = ref.watch(descriptionNotifierProvider);
                return Column(
                  children: [
                    const Header(text: 'Add Note'),
                    TextInput(
                      text: 'Title',
                      icon: Icons.text_fields,
                      inputType: TextInputType.text,
                      controller: _titleController,
                      error: titleField.error,
                      removeError: () => ref.read(titleStateNotifierProvider.notifier).updateError(null),
                      isType: "title",
                      maxLength: 20,
                    ),
                    TextInput(
                      text: 'Description',
                      icon: Icons.text_snippet,
                      inputType: TextInputType.text,
                      controller: _descController,
                      error: descriptionField.error,
                      removeError: () => ref.read(descriptionNotifierProvider.notifier).updateError(null),
                      isType: "description",
                      maxLength: 200,
                    ),
                    SubmitButton(
                      text: 'SAVE',
                      onClicked: () {
                        final title = ref.read(titleStateNotifierProvider.notifier).validate(_titleController.text);
                        final description = ref.read(descriptionNotifierProvider.notifier).validate(_descController.text);
                        if(title || description) return;
                        _addTask();
                      },
                      formKey: _formKey,
                    )
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
