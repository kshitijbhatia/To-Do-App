// ignore_for_file: avoid_unnecessary_containers
import 'package:flutter/material.dart';
import 'package:todo_app/app_theme_settings.dart';
import 'package:todo_app/ui/common_widgets/add_edit_reg_header.dart';
import 'package:todo_app/ui/register_page/register_page_form.dart';

class RegisterPageHome extends StatefulWidget {
  const RegisterPageHome({super.key});

  @override
  State<RegisterPageHome> createState() => _RegisterPageHomeState();
}

class _RegisterPageHomeState extends State<RegisterPageHome> {

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
                const Header(text: 'Registration Page'),
                30.height,
                Container(
                  child: const Text(
                    'Register',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 45,
                      color: Colors.white,
                    ),
                  ),
                ),
                20.height,
                const RegisterPageForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
