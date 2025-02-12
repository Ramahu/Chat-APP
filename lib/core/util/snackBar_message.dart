import 'package:flutter/material.dart';
import 'colors.dart';

class SnackBarMessage {
   showSnackBar(
      {required String message, required BuildContext context , required bool isError }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(color: white),
        ),
        backgroundColor: isError ? redAccent : green ,
      ),
    );
  }
}
