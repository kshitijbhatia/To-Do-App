import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/db/db_user_controller.dart';
import 'package:todo_app/constants.dart';
import 'package:todo_app/models/user.dart';
import 'package:todo_app/ui/common_widgets/snack_bar.dart';
import 'package:todo_app/ui/common_widgets/text_input.dart';
import 'package:todo_app/ui/home_page/home_page.dart';

class LoginPageForm extends StatefulWidget {
  const LoginPageForm({super.key, required this.emailController, required this.passwordController, required this.formKey});

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final GlobalKey<FormState> formKey;

  @override
  State<LoginPageForm> createState() => _LoginPageFormState();
}

class _LoginPageFormState extends State<LoginPageForm> {
  bool _rememberMe = false;

  String? _emailError;
  String? _passError;

  String? _checkEmail(String email){

    String validError = 'Please enter a valid Email';

    List<String> emailList= email.split('@');

    if(emailList.length == 1){
      return validError;
    }else if(emailList[0].isEmpty || emailList[1].isEmpty){
      return validError;
    }

    emailList = emailList[1].split('.');
    if(emailList.length == 1){
      return validError;
    }else if(emailList[0].isEmpty || emailList[1].isEmpty){
      return validError;
    }else if(emailList[1] != 'com'){
      return validError;
    }

    return null;
  }

  void _loginButtonClicked() async{

    if(_checkEmail(widget.emailController.text) != null){
      setState(() {
        _emailError = _checkEmail(widget.emailController.text);
      });
      return;
    }
    UserController auth = UserController.getInstance;
    var response = await auth.loginUser(widget.emailController.text.trim(), widget.passwordController.text.trim());
    if(response['status'] == 'failure'){
      ScaffoldMessenger.of(context).showSnackBar(getCustomSnackBar('Invalid Email or Password'));
    }else if(response['status'] == 'error'){
      ScaffoldMessenger.of(context).showSnackBar(getCustomSnackBar('Error Occurred While Login'));
    }else if(response['status'] == 'success'){
      User currentUser = response['data'];
      setState(() {
        widget.emailController.clear();
        widget.passwordController.clear();
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String currentUserJson = jsonEncode(currentUser.toJson());
      prefs.setString('user', currentUserJson);
      prefs.setBool('remember', _rememberMe);

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
          child: Form(
            key: widget.formKey,
            child: Column(
              children: [
                TextInput(
                  text: 'Email',
                  icon: Icons.person,
                  inputType: TextInputType.emailAddress,
                  controller: widget.emailController,
                  error: _emailError,
                  removeError: (){
                    setState(() {
                      _emailError = null;
                    });
                  },
                  isType: "email",
                  maxLength: 40,
                ),
                TextInput(
                  text: 'Password',
                  icon: Icons.lock_outline,
                  inputType: TextInputType.visiblePassword,
                  controller: widget.passwordController,
                  error: _passError,
                  removeError: (){
                    setState(() {
                      _passError = null;
                    });
                  },
                  isType: "password",
                  maxLength: 20,
                ),
                20.height,
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    children: [
                      Checkbox(
                        fillColor: MaterialStatePropertyAll(appTheme.getPrimaryColor),
                        value: _rememberMe,
                        onChanged: (value) {
                          setState(() {
                            _rememberMe = !_rememberMe;
                          });
                        },
                        side: BorderSide(color: appTheme.getPrimaryColor, width: 2),
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
          )
        ),
        Transform.translate(
          offset: Offset(0, -height/30),
          child: GestureDetector(
            onTap: () {
              if(widget.formKey.currentState!.validate()){
                _loginButtonClicked();
              }
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
