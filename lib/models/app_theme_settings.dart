import 'package:flutter/material.dart';

class AppThemeSettings {
  static const Color _primaryColor = Color.fromRGBO(24, 56, 131, 1);
  static const BoxDecoration _backgroundTheme = BoxDecoration(
    gradient: LinearGradient(
      colors: [Color.fromRGBO(24, 56, 131, 1), Colors.white],
      begin: Alignment.bottomLeft,
      end: Alignment.topRight,
    ),
  );
  static const BoxDecoration _headerTheme = BoxDecoration(
    color: _primaryColor,
    boxShadow: [
      BoxShadow(
          color: Colors.grey,
          offset: Offset(0, 3),
          spreadRadius: 2,
          blurRadius: 3),
    ],
  );

  static const TextStyle _headerTextTheme = TextStyle(color: Colors.white, fontSize: 24);

  Color get getPrimaryColor => _primaryColor;

  BoxDecoration get getBackgroundTheme => _backgroundTheme;

  BoxDecoration get getHeaderTheme => _headerTheme;

  TextStyle get getHeaderTextTheme => _headerTextTheme;
}

class ScreenSize {
  // static double width;
  // static double height;

  static double getHeight(BuildContext context) {
    return MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top;
  }

  static double getWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }
}
