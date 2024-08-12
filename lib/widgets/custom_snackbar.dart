import 'package:flutter/material.dart';

class CustomSnackBar {
  static void show(
      BuildContext context, String message, Color backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Center(
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16.0,
            ),
          ),
        ),
        duration: const Duration(milliseconds: 500),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.fixed,
      ),
    );
  }
}
