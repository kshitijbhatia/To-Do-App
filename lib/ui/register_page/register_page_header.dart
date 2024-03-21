import 'package:flutter/material.dart';
import 'package:todo_app/models/app_theme_settings.dart';

class RegisterPageHeader extends StatelessWidget {
  const RegisterPageHeader({super.key});

  @override
  Widget build(BuildContext context) {
    AppThemeSettings appTheme = AppThemeSettings();
    double width = ScreenSize.getWidth(context);
    double height = ScreenSize.getHeight(context);

    return Container(
      width: width,
      height: height / 10,
      decoration: appTheme.getHeaderTheme,
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back),
            color: Colors.white,
            iconSize: 30,
          ),
          Container(
            margin: EdgeInsets.only(left: width / 15),
            child: Text(
              'Registration Page',
              style: appTheme.getHeaderTextTheme,
            ),
          )
        ],
      ),
    );
  }
}
