// ignore_for_file: sized_box_for_whitespace
import 'dart:developer';
import 'package:flutter/material.dart';
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

  String? _checkEmail(String email){

    String _validError = 'Please enter a valid Email';

    List<String> emailList= email.split('@');

    if(emailList.length == 1){
      return _validError;
    }else if(emailList[0].isEmpty || emailList[1].isEmpty){
      return _validError;
    }

    emailList = emailList[1].split('.');
    if(emailList.length == 1){
      return _validError;
    }else if(emailList[0].isEmpty || emailList[1].isEmpty){
      return _validError;
    }else if(emailList[1] != 'com'){
      return _validError;
    }

    return null;
  }

  void registerUser() async {

    if(_checkEmail(_emailController.text)  != null){
      setState(() {
        emailError = _checkEmail(_emailController.text);
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
        User currentUser = response['data'];
        setState(() {
          _emailController.clear();
          _passwordController.clear();
          _usernameController.clear();
          _confirmPassController.clear();
        });
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

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double width = ScreenSize.getWidth(context);
    return Container(
      width: width,
      child: Form(
        key: formKey,
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
              formKey: formKey,
            )
          ],
        ),
      )
    );
  }
}
