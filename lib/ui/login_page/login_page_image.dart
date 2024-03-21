import 'package:flutter/material.dart';
import 'package:todo_app/models/app_theme_settings.dart';

class LoginPageImage extends StatelessWidget {
  const LoginPageImage({super.key});

  @override
  Widget build(BuildContext context) {
    double width = ScreenSize.getWidth(context);
    double height = ScreenSize.getHeight(context);

    return Container(
      width: width,
      height: height/7,
      margin: const EdgeInsets.symmetric(horizontal: 15),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(40),
          bottomLeft: Radius.circular(40),
        ),
      ),
      child: Image.asset(
        'assets/tvsimage.png',
        fit: BoxFit.contain,
      ),
    );
  }
}
