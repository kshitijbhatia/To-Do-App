// ignore_for_file: sized_box_for_whitespace, avoid_unnecessary_containers
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/models/app_theme_settings.dart';
import 'package:todo_app/ui/login_page/login_page_form.dart';
import 'package:todo_app/ui/login_page/login_page_header.dart';
import 'package:todo_app/ui/login_page/login_page_image.dart';
import 'package:todo_app/ui/register_page/register_page_home.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

extension on num{
  SizedBox get height => SizedBox(height: toDouble(),);
}

class _LoginPageState extends State<LoginPage> {
  
  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    AppThemeSettings appTheme = AppThemeSettings();
    double width = ScreenSize.getWidth(context);
    double height = ScreenSize.getHeight(context);

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            width: width,
            height: height,
            decoration: appTheme.getBackgroundTheme,
            child: Column(
              children: [
                const LoginPageHeader(),   
                50.height,
                const LoginPageImage(),    
                30.height,
                const LoginPageForm(),     
                30.height,
                Container(
                  child: RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        const TextSpan(
                          text: "Don't have an account? ",
                          style: TextStyle(fontSize: 20, fontFamily: 'Roboto'),
                        ),
                        TextSpan(
                          text: "Sign Up",
                          style: const TextStyle(
                              fontSize: 20,
                              decoration: TextDecoration.underline,
                              fontFamily: 'Roboto'),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const RegisterPageHome(),
                                ),
                              );
                            },
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
