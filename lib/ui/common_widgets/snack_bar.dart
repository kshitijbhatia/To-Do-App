import 'package:flutter/material.dart';

SnackBar getCustomSnackBar(String message) {
  return SnackBar(
    content: Text(
      message,
      style: const TextStyle(color: Colors.white, fontSize: 18),
    ),
    duration: const Duration(seconds: 2),
    backgroundColor: const Color.fromRGBO(70, 98, 224, 1),
  );
}