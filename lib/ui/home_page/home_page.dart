import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:todo_app/models/app_theme_settings.dart';
import 'package:todo_app/models/user.dart';
import 'package:todo_app/ui/add_page/add_home_page.dart';
import 'package:todo_app/ui/home_page/home_page_header.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.currentUser});

  final User currentUser;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AppThemeSettings appTheme = AppThemeSettings();

  @override
  Widget build(BuildContext context) {
    double width = ScreenSize.getWidth(context);
    double height = ScreenSize.getHeight(context);

    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddPageHome(currentUser: widget.currentUser),
              ),
            );
          },
          backgroundColor: appTheme.getPrimaryColor,
          shape: const CircleBorder(),
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            width: width,
            height: height,
            decoration: appTheme.getBackgroundTheme,
            child: Column(
              children: [
                HomePageHeader(
                  username: widget.currentUser.getUserName,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
