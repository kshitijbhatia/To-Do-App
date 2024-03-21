import 'package:flutter/material.dart';
import 'package:todo_app/models/app_theme_settings.dart';

class SubmitButton extends StatelessWidget {
  const SubmitButton({super.key, required this.onClicked});

  final Function() onClicked; 

  @override
  Widget build(BuildContext context) {
    AppThemeSettings appTheme = AppThemeSettings();
    double width = ScreenSize.getWidth(context);
    double height = ScreenSize.getHeight(context);

    return Container(
      margin: const EdgeInsets.only(left: 15, right: 15, top: 30),
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: const MaterialStatePropertyAll(Colors.white),
          foregroundColor: MaterialStatePropertyAll(appTheme.getPrimaryColor),
          minimumSize: MaterialStatePropertyAll(
            Size(width, height / 16),
          ),
          elevation: const MaterialStatePropertyAll(5),
          shape: MaterialStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        onPressed: () {
          onClicked();
        },
        child: const Text(
          'Login',
          style: TextStyle(fontFamily: 'Roboto', fontSize: 24),
        ),
      ),
    );
  }
}
