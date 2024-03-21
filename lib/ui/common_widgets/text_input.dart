import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:todo_app/models/app_theme_settings.dart';

class TextInput extends StatefulWidget {
  const TextInput({super.key, required this.text, required this.icon, required this.inputType, required this.controller, required this.error, required this.removeError});

  final String text;
  final IconData icon;
  final TextInputType inputType;
  final TextEditingController controller;
  final String? error;
  final Function removeError;

  @override
  State<TextInput> createState() => _TextInputState();
}

class _TextInputState extends State<TextInput> {
  AppThemeSettings appTheme = AppThemeSettings();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 25, left: 15, right: 15),
      padding: const EdgeInsets.only(left: 15, bottom: 5),
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color.fromRGBO(0,0,0, 1),),
      ),
      child : TextFormField(
        controller: widget.controller,
        key,
        onChanged: (value){
          widget.removeError();
        },
        decoration: InputDecoration(
          icon: Icon(widget.icon),
          iconColor: appTheme.getPrimaryColor,
          labelText: widget.text,
          labelStyle: const TextStyle(color: Color.fromRGBO(0,0,0,0.7), fontSize: 18),
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          errorText: widget.error,
          errorBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none,
          errorStyle: const TextStyle(fontFamily: 'Roboto', fontSize: 12,)
        ),
      ),
    );
  }
}
