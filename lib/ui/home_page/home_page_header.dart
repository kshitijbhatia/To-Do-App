import 'package:flutter/material.dart';
import 'package:todo_app/models/app_theme_settings.dart';
import 'package:todo_app/ui/home_page/home_page.dart';

class HomePageHeader extends StatefulWidget {
  const HomePageHeader({super.key, required this.username});

  final String username;

  @override
  State<HomePageHeader> createState() => _HomePageHeaderState();
}

class _HomePageHeaderState extends State<HomePageHeader> {
  AppThemeSettings appTheme = AppThemeSettings();

  @override
  Widget build(BuildContext context) {
    double width = ScreenSize.getWidth(context);
    double height = ScreenSize.getHeight(context);

    return Container(
      decoration: appTheme.getHeaderTheme,
      height: height/10,
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Welcome ${widget.username}', style: const TextStyle(color: Colors.white, fontFamily: 'Roboto', fontSize: 22),),
          GestureDetector(
            onTap: (){
              Navigator.pop(context);
            },
            child: const Text('LOGOUT', style: TextStyle(color: Colors.white, fontFamily: 'Roboto', fontSize: 18)),
          )
        ],
      ),
    );
  }
}
