import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/db/database.dart';
import 'package:todo_app/db/authentication.dart';
import 'package:todo_app/models/app_theme_settings.dart';
import 'package:todo_app/models/user.dart';
import 'package:todo_app/ui/common_widgets/text_input.dart';
import 'package:todo_app/ui/home_page/home_page.dart';

class LoginPageForm extends StatefulWidget {
  const LoginPageForm({super.key});

  @override
  State<LoginPageForm> createState() => _LoginPageFormState();
}

class _LoginPageFormState extends State<LoginPageForm> {
  
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String? emailError;
  String? passError;

  void loginButtonClicked() async{

    if(emailController.text == '' || passwordController.text == ''){
      setState(() {
        emailError = emailController.text == '' ? 'Enter a valid Email' : null;
        passError = passwordController.text == '' ? 'Enter a valid password' : null;
      });
      return;
    }

    Authentication auth = Authentication.getInstance;
    var response = await auth.loginUser(emailController.text, passwordController.text);
    if(response['status'] == 'failure'){
      setState(() {
        emailError = response['msg'] == 'Incorrect Email' ? response['msg'] as String : null;
        passError = response['msg'] == 'Incorrect Password' ? response['msg'] as String : null;
      });
    }else if(response['status'] == 'error'){
      // Code for error in login
    }else if(response['status'] == 'success'){
      User currentUser = response['msg'] as User;
      log('Success : ${currentUser.getUserName}');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(currentUser: currentUser),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = ScreenSize.getWidth(context);
    double height = ScreenSize.getHeight(context);
    AppThemeSettings appTheme = AppThemeSettings();

    return Container(
      width: width,
      margin: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(children: [
        Container(
          padding: const EdgeInsets.only(bottom: 45),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              TextInput(
                text: 'Email',
                icon: Icons.person,
                inputType: TextInputType.emailAddress,
                controller: emailController,
                error: emailError,
                removeError: (){
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
                removeError: (){
                  setState(() {
                    passError = null;
                  });
                },
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  children: [
                    Checkbox(
                      value: false,
                      onChanged: (value) {},
                      side:
                          BorderSide(color: appTheme.getPrimaryColor, width: 2),
                    ),
                    const Text(
                      'Remember Me',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 18,
                        color: Color.fromRGBO(0, 0, 0, 0.5),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        Transform.translate(
          offset: Offset(0, -height/30),
          child: GestureDetector(
            onTap: () {
              loginButtonClicked();
            },
            child : Container(
                width: width / 2,
                height: height / 15,
                decoration: BoxDecoration(
                  color: appTheme.getPrimaryColor,
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Login',
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          color: Colors.white,
                          fontSize: 22,
                      ),
                    ),
                    CircleAvatar(
                      backgroundColor: Color.fromRGBO(7, 15, 43, 1),
                      foregroundColor: Colors.white,
                      child: Icon(Icons.arrow_forward_ios_outlined),
                    )
                  ],
                ),
              ),
            ),
        ),
        ],
      ),
    );
  }
}