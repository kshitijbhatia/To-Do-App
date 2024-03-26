import 'package:flutter/material.dart';
import 'package:todo_app/constants.dart';

class Header extends StatefulWidget {
  const Header({super.key, required this.text});

  final String text;

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {

  AppThemeSettings appTheme = AppThemeSettings();

  @override
  Widget build(BuildContext context) {
    double width = ScreenSize.getWidth(context);
    double height = ScreenSize.getHeight(context);

    return Container(
      width: width,
      height: height / 14,
      decoration: appTheme.getHeaderTheme,
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              Navigator.pop(context, 'back');
            },
            icon: const Icon(Icons.arrow_back),
            color: Colors.white,
            iconSize: 30,
          ),
          Container(
            margin: EdgeInsets.only(left: width / 15),
            child: Text(
              widget.text,
              style: appTheme.getHeaderTextTheme,
            ),
          )
        ],
      ),
    );
  }
}