import 'package:flutter/material.dart';
import 'package:todo_app/models/app_theme_settings.dart';

class LoginPageHeader extends StatelessWidget {
  const LoginPageHeader({super.key});

  @override
  Widget build(BuildContext context) {
    AppThemeSettings appTheme = AppThemeSettings();
    double width = ScreenSize.getWidth(context);
    double height = ScreenSize.getHeight(context);

    return Container(
      height: height / 10,
      width: width,
      decoration: appTheme.getHeaderTheme,
      padding: const EdgeInsets.only(left: 15),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Login Page',
          style: appTheme.getHeaderTextTheme
        ),
      ),
    );
  }
}
