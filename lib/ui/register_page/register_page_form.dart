// ignore_for_file: sized_box_for_whitespace
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/db/db_task_controller.dart';
import 'package:todo_app/db/db_user_controller.dart';
import 'package:todo_app/constants.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/models/form_data.dart';
import 'package:todo_app/models/user.dart';
import 'package:todo_app/ui/common_widgets/snack_bar.dart';
import 'package:todo_app/ui/common_widgets/submit_button.dart';
import 'package:todo_app/ui/common_widgets/text_input.dart';
import 'package:todo_app/ui/home_page/home_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RegisterPageForm extends ConsumerStatefulWidget {
  const RegisterPageForm({super.key});

  @override
  ConsumerState<RegisterPageForm> createState() => _RegisterPageFormState();
}

class _RegisterPageFormState extends ConsumerState<RegisterPageForm> {
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;
  late TextEditingController _emailController;
  late TextEditingController _confirmPassController;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
    _emailController = TextEditingController();
    _confirmPassController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    _confirmPassController.dispose();
  }

  void registerUser() async {
    final String? checkEmailError = checkEmail(_emailController.text);
    if(checkEmailError != null){
      ref.read(emailStateNotifierProvider.notifier).updateError(checkEmailError);
      return;
    }

    if (_confirmPassController.text.trim() == _passwordController.text.trim()) {
      UserController auth = ref.read(userControllerProvider);
      User user = User(
        email: _emailController.text,
        password: _passwordController.text,
        username: _usernameController.text,
        createdAt: DateTime.now().toString(),
      );

      final userController = ref.read(userControllerProvider);
      final response = await userController.registerUser(user);

      if (response['status'] == 'failure') {
        ScaffoldMessenger.of(context).showSnackBar(getCustomSnackBar('Email Already Exists, Please Login'));
      }else if(response['status'] == 'error'){
        ScaffoldMessenger.of(context).showSnackBar(getCustomSnackBar('Error Occurred While Registering'));
      } else if (response['status'] == 'success') {

        // Storing the current user credentials in shared preferences
        User currentUser = response['data'];
        SharedPreferences prefs = ref.read(sharedPreferencesProvider);
        String currentUserJson = jsonEncode(currentUser.toJson());
        prefs.setString(Constants.user, currentUserJson);
        prefs.setBool(Constants.rememberUser, false);
        ref.read(userStateNotifierProvider.notifier).setUser(user);

        // Navigating to Home Page
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage(),),);
      }
    } else {
      ref.read(confirmPasswordStateNotifierProvider.notifier).updateError('The passwords do not match');
    }
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double width = ScreenSize.getWidth(context);

    final emailField = ref.watch(emailStateNotifierProvider);
    final passwordField = ref.watch(passwordStateNotifierProvider);
    final usernameField = ref.watch(usernameStateNotifierProvider);
    final confirmPasswordField = ref.watch(confirmPasswordStateNotifierProvider);

    log('Rebuilt');
    return Container(
      width: width,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextInput(
              text: 'Username',
              icon: Icons.person,
              inputType: TextInputType.name,
              controller: _usernameController,
              error: usernameField.error,
              removeError: () => ref.read(usernameStateNotifierProvider.notifier).validate(_usernameController.text),
              isType: "username",
              maxLength: 20,
            ),
            TextInput(
              text: 'Email',
              icon: Icons.email_outlined,
              inputType: TextInputType.emailAddress,
              controller: _emailController,
              error: emailField.error,
              removeError: () => ref.read(emailStateNotifierProvider.notifier).validate(_emailController.text),
              isType: "email",
              maxLength: 40,
            ),
            TextInput(
              text: 'Password',
              icon: Icons.lock_outline,
              inputType: TextInputType.visiblePassword,
              controller: _passwordController,
              error: passwordField.error,
              removeError: () => ref.read(passwordStateNotifierProvider.notifier).validate(_passwordController.text),
              isType: "password",
              maxLength: 20,
            ),
            TextInput(
              text: 'Confirm Password',
              icon: Icons.lock_outline,
              inputType: TextInputType.visiblePassword,
              controller: _confirmPassController,
              error: confirmPasswordField.error,
              removeError: () => ref.read(confirmPasswordStateNotifierProvider.notifier).validate(_confirmPassController.text),
              isType: "confirm-password",
              maxLength: 20,
            ),
            SubmitButton(
              text: 'Login',
              onClicked: (){
                final emailEmptyError = ref.read(emailStateNotifierProvider.notifier).validate(_emailController.text);
                final passwordEmptyError = ref.read(passwordStateNotifierProvider.notifier).validate(_passwordController.text);
                final usernameEmptyError = ref.read(usernameStateNotifierProvider.notifier).validate(_usernameController.text);
                final confirmPasswordEmptyError = ref.read(confirmPasswordStateNotifierProvider.notifier).validate(_confirmPassController.text);

                if(!emailEmptyError && !passwordEmptyError && !usernameEmptyError && !confirmPasswordEmptyError){
                  registerUser();
                }
              },
              formKey: _formKey,
            )
          ],
        ),
      )
    );
  }
}
