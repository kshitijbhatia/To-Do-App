// ignore_for_file: sized_box_for_whitespace
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:todo_app/db/db_user_controller.dart';
import 'package:todo_app/app_theme_settings.dart';
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
  late TextEditingController usernameController;
  late TextEditingController passwordController;
  late TextEditingController emailController;
  late TextEditingController confirmPassController;

  String? confirmPassError;
  String? emailError;
  String? userNameError;
  String? passError;

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController();
    passwordController = TextEditingController();
    emailController = TextEditingController();
    confirmPassController = TextEditingController();
  }

  void registerUser() async {
    if (usernameController.text == '' ||
        passwordController.text == '' ||
        confirmPassController.text == '' ||
        emailController.text == '') {
      setState(() {
        confirmPassError = confirmPassController.text == ''
            ? 'Please enter password again'
            : null;
        emailError =
            emailController.text == '' ? 'Please enter your email' : null;
        passError =
            passwordController.text == '' ? 'Please enter your password' : null;
        userNameError =
            usernameController.text == '' ? 'Please enter you User Name' : null;
      });
      return;
    }
    if (confirmPassController.text.trim() == passwordController.text.trim()) {
      UserController auth = UserController.getInstance;
      User user = User(
        email: emailController.text,
        password: passwordController.text,
        username: usernameController.text,
        createdAt: DateTime.now().toString(),
      );

      var response = await auth.registerUser(user);

      if (response['status'] == 'failure') {
        setState(() {
          emailError = 'Email Already Exists!';
        });
      }else if(response['status'] == 'error'){
        log('${response['msg']} : ${response['data']}');
        ScaffoldMessenger.of(context).showSnackBar(getCustomSnackBar('Error Occurred While Registering'));
      } else if (response['status'] == 'success') {
        User currentUser = response['data'];
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

  @override
  Widget build(BuildContext context) {
    double width = ScreenSize.getWidth(context);
    return Container(
      width: width,
      child: Column(
        children: [
          TextInput(
            text: 'Username',
            icon: Icons.person,
            inputType: TextInputType.name,
            controller: usernameController,
            error: userNameError,
            removeError: () {
              setState(() {
                userNameError = null;
              });
            },
          ),
          TextInput(
            text: 'Email',
            icon: Icons.email_outlined,
            inputType: TextInputType.emailAddress,
            controller: emailController,
            error: emailError,
            removeError: () {
              setState(() {
                emailError = null;
              });
            },
          ),
          TextInput(
            text: 'Password',
            icon: Icons.lock_outline,
            inputType: TextInputType.visiblePassword,
            controller: passwordController,
            error: passError,
            removeError: () {
              setState(() {
                passError = null;
              });
            },
          ),
          TextInput(
            text: 'Confirm Password',
            icon: Icons.lock_outline,
            inputType: TextInputType.visiblePassword,
            controller: confirmPassController,
            error: confirmPassError,
            removeError: () {
              setState(() {
                confirmPassError = null;
              });
            },
          ),
          SubmitButton(
            text: 'Login',
            onClicked: registerUser,
          )
        ],
      ),
    );
  }
}
