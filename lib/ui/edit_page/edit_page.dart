import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/db/db_task_controller.dart';
import 'package:todo_app/constants.dart';
import 'package:todo_app/models/form_data.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/ui/common_widgets/header.dart';
import 'package:todo_app/ui/common_widgets/snack_bar.dart';
import 'package:todo_app/ui/common_widgets/submit_button.dart';
import 'package:todo_app/ui/common_widgets/text_input.dart';

class EditHomePage extends ConsumerStatefulWidget {
  const EditHomePage({super.key, required this.currentTask});

  final Task currentTask;

  @override
  ConsumerState<EditHomePage> createState() => _EditHomePageState();
}

class _EditHomePageState extends ConsumerState<EditHomePage> {
  AppThemeSettings appTheme = AppThemeSettings();

  late TextEditingController _titleController;
  late TextEditingController _desController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.currentTask.getTitle);
    _desController = TextEditingController(text: widget.currentTask.getDescription);
  }

  updateTask() async {
    Task updatedTask = Task(
      id: widget.currentTask.getId,
      email: widget.currentTask.getEmail,
      title: _titleController.text.trim(),
      description: _desController.text.trim(),
      createdAt: DateTime.now().toString(),
    );

    final taskController = ref.read(taskProvider);
    final response = await taskController.updateTask(updatedTask);

    if(response['status'] == 'success'){
      ref.read(titleStateNotifierProvider.notifier).updateError(null);
      ref.read(descriptionNotifierProvider.notifier).updateError(null);
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
            child: Consumer(
              builder : (context, ref, child) {
                final titleField = ref.watch(titleStateNotifierProvider);
                final descriptionField = ref.watch(descriptionNotifierProvider);
                return Column(
                  children: [
                    const Header(text: 'Edit Note'),
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
                      controller: _desController,
                      error: descriptionField.error,
                      removeError: () => ref.read(descriptionNotifierProvider.notifier).updateError(null),
                      isType: "description",
                      maxLength: 200,
                    ),
                    SubmitButton(
                      text: 'UPDATE',
                      onClicked: (){
                        final title = ref.read(titleStateNotifierProvider.notifier).validate(_titleController.text);
                        final description = ref.read(descriptionNotifierProvider.notifier).validate(_desController.text);
                        if(title || description) return;
                        updateTask();
                      },
                      formKey: _formKey,
                    )
                  ],
                );
              },
            ),
          )
        ),
      ),
    );
  }
}
