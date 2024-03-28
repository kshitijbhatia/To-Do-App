import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:todo_app/constants.dart';

class TextInput extends StatefulWidget {
  const TextInput({
    super.key,
    required this.text,
    required this.icon,
    required this.inputType,
    required this.controller,
    required this.error,
    required this.removeError,
    required this.isType,
    required this.maxLength
  });

  final String text;
  final IconData icon;
  final TextInputType inputType;
  final TextEditingController controller;
  final String? error;
  final Function removeError;
  final String isType;
  final int maxLength;

  @override
  State<TextInput> createState() => _TextInputState();
}

class _TextInputState extends State<TextInput> {
  AppThemeSettings appTheme = AppThemeSettings();

  bool _passwordIsVisible = false;

  void _changePasswordVisibility() {
    setState(() {
      _passwordIsVisible = !_passwordIsVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 25, left: 15, right: 15),
      padding: const EdgeInsets.only(left: 10,right: 10, top: 5, bottom: 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color.fromRGBO(0, 0, 0, 1),
        ),
      ),
      alignment: Alignment.center,
      child:TextFormField(
        obscureText: (widget.isType == "password" ||
            widget.isType == "confirm-password") &&
            !_passwordIsVisible
            ? true
            : false,
        maxLines: widget.isType == "description" ? null : 1,
        autovalidateMode: widget.controller.text.isEmpty
            ? AutovalidateMode.disabled
            : AutovalidateMode.onUserInteraction,
        maxLength: widget.maxLength,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Please enter some text';
          }
          return null;
        },
        onTapOutside: (event) {
          FocusScopeNode focusNode = FocusScope.of(context);
          if (!focusNode.hasPrimaryFocus) {
            focusNode.unfocus();
          }
        },
        controller: widget.controller,
        onChanged: (value) {
          widget.removeError();
        },
        decoration: InputDecoration(
            icon: Icon(widget.icon),
            iconColor: appTheme.getPrimaryColor,
            contentPadding: const EdgeInsets.only(top: 2,),
            labelText: widget.text,
            labelStyle: const TextStyle(
                color: Color.fromRGBO(0, 0, 0, 0.7), fontSize: 18),
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            errorText: widget.error,
            errorBorder: InputBorder.none,
            focusedErrorBorder: InputBorder.none,
            errorStyle: const TextStyle(
              fontFamily: 'Roboto',
              fontSize: 14,
            ),
            suffixIcon: widget.isType == "password"
                ? IconButton(
                onPressed: _changePasswordVisibility,
                icon: _passwordIsVisible
                    ? const Icon(Icons.visibility)
                    : const Icon(Icons.visibility_off))
                : 0.height,
            suffixIconColor: appTheme.getPrimaryColor,
        ),
      ),
    );
  }
}

