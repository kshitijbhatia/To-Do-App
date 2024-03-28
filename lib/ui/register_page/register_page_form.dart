// ignore_for_file: sized_box_for_whitespace
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/db/db_user_controller.dart';
import 'package:todo_app/constants.dart';
import 'package:todo_app/models/user.dart';
import 'package:todo_app/ui/common_widgets/snack_bar.dart';
import 'package:todo_app/ui/common_widgets/submit_button.dart';
import 'package:todo_app/ui/common_widgets/text_input.dart';
import 'package:todo_app/ui/home_page/home_page.dart';

class RegisterPageForm extends StatefulWidget {
  const RegisterPageForm({super.key});

  @override
  State<RegisterPageForm> createState() => _RegisterPageFormState();
}

class _RegisterPageFormState extends State<RegisterPageForm> {
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;
  late TextEditingController _emailController;
  late TextEditingController _confirmPassController;

  String? confirmPassError;
  String? emailError;
  String? userNameError;
  String? passError;

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

    if(checkEmail(_emailController.text)  != null){
      setState(() {
        emailError = checkEmail(_emailController.text);
      });
      return;
    }

    if (_confirmPassController.text.trim() == _passwordController.text.trim()) {
      UserController auth = UserController.getInstance;
      User user = User(
        email: _emailController.text,
        password: _passwordController.text,
        username: _usernameController.text,
        createdAt: DateTime.now().toString(),
      );

      var response = await auth.registerUser(user);

      if (response['status'] == 'failure') {
        setState(() {
          ScaffoldMessenger.of(context).showSnackBar(getCustomSnackBar('Email Already Exists, Please Login'));
        });
      }else if(response['status'] == 'error'){
        ScaffoldMessenger.of(context).showSnackBar(getCustomSnackBar('Error Occurred While Registering'));
      } else if (response['status'] == 'success') {

        // Storing the current user credentials in shared preferences
        User currentUser = response['data'];
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String currentUserJson = jsonEncode(currentUser.toJson());
        prefs.setString(Constants.user, currentUserJson);
        prefs.setBool(Constants.rememberUser, false);

        // Clearing all input fields
        setState(() {
          _emailController.clear();
          _passwordController.clear();
          _usernameController.clear();
          _confirmPassController.clear();
        });

        // Navigating to Home Page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(currentUser: currentUser),
          ),
        );

      }
    } else {
      setState(() {
        confirmPassError = 'The passwords do not match';
      });
    }
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double width = ScreenSize.getWidth(context);
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
              error: userNameError,
              removeError: () {
                setState(() {
                  userNameError = null;
                });
              },
              isType: "username",
              maxLength: 20,
            ),
            TextInput(
              text: 'Email',
              icon: Icons.email_outlined,
              inputType: TextInputType.emailAddress,
              controller: _emailController,
              error: emailError,
              removeError: () {
                setState(() {
                  emailError = null;
                });
              },
              isType: "email",
              maxLength: 40,
            ),
            TextInput(
              text: 'Password',
              icon: Icons.lock_outline,
              inputType: TextInputType.visiblePassword,
              controller: _passwordController,
              error: passError,
              removeError: () {
                setState(() {
                  passError = null;
                });
              },
              isType: "password",
              maxLength: 20,
            ),
            TextInput(
              text: 'Confirm Password',
              icon: Icons.lock_outline,
              inputType: TextInputType.visiblePassword,
              controller: _confirmPassController,
              error: confirmPassError,
              removeError: () {
                setState(() {
                  confirmPassError = null;
                });
              },
              isType: "confirm-password",
              maxLength: 20,
            ),
            SubmitButton(
              text: 'Login',
              onClicked: registerUser,
              formKey: _formKey,
            )
          ],
        ),
      )
    );
  }
}
