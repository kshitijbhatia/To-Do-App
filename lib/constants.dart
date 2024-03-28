import 'package:flutter/material.dart';


// Constants used in shared preference
class Constants{
  static const user = 'user';
  static const rememberUser = 'remember';
}

// Extension for Sized box
extension getSizedBox on num{
  SizedBox get height => SizedBox(height: toDouble(),);
}

// App Theme
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

// Getter methods for the size of the screen
class ScreenSize {
  static double getHeight(BuildContext context) {
    return MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top;
  }

  static double getWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }
}

// Function for email validation
String? checkEmail(String email){

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
