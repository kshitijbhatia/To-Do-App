import 'package:flutter/material.dart';
import 'package:todo_app/app_theme_settings.dart';

class SubmitButton extends StatelessWidget {
  const SubmitButton({super.key, required this.text,required this.onClicked});

  final Function() onClicked;
  final String text;

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
        child: Text(
          text,
          style: const TextStyle(fontFamily: 'Roboto', fontSize: 24),
        ),
      ),
    );
  }
}
