import 'package:chat/core/responsive_ui.dart';
import 'package:chat/core/util/colors.dart';
import 'package:flutter/material.dart';


class AppTheme {
  // Light Theme
  static ThemeData lightTheme(BuildContext context) {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: indigoAccent,
      colorScheme: ColorScheme.light(
        primary: indigoAccent,
        secondary: defaultBlue2,
      ),
      scaffoldBackgroundColor: white,
      appBarTheme: AppBarTheme(
        backgroundColor: white,
        iconTheme: IconThemeData(color: black),
        titleTextStyle: TextStyle(
          color: black,
          fontSize: Responsive.textMultiplier(context) * 5,
          fontWeight: FontWeight.bold,
        ),
        elevation: 0,
      ),
      textTheme: TextTheme(
        headlineLarge: TextStyle(fontSize: Responsive.textMultiplier(context) * 7 , fontWeight: FontWeight.bold, color: black),
        bodyLarge: TextStyle(fontSize: Responsive.textMultiplier(context) * 5, color: black87),
        bodyMedium: TextStyle(fontSize: Responsive.textMultiplier(context) * 4, color: black54),
      ),
      // buttonTheme: ButtonThemeData(
      //   buttonColor: indigoAccent,
      //   textTheme: ButtonTextTheme.primary,
      // ),
    );
  }

  // Dark Theme
  static ThemeData darkTheme(BuildContext context) {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: indigoAccent,
      colorScheme: ColorScheme.dark(
        primary: indigoAccent,
        secondary: defaultBlue2,
      ),
      scaffoldBackgroundColor: grey[900],
      appBarTheme: AppBarTheme(
        backgroundColor: grey[900],
        iconTheme: IconThemeData(color: white),
        titleTextStyle: TextStyle(
          color: white,
          fontSize: Responsive.textMultiplier(context) * 5,
          fontWeight: FontWeight.bold,
        ),
        elevation: 0,
      ),
      textTheme: TextTheme(
        headlineLarge: TextStyle(fontSize: Responsive.textMultiplier(context) * 7, fontWeight: FontWeight.bold, color: white),
        bodyLarge: TextStyle(fontSize: Responsive.textMultiplier(context) * 5, color: white70),
        bodyMedium: TextStyle(fontSize: Responsive.textMultiplier(context) * 4, color: white60),
      ),
      // buttonTheme: ButtonThemeData(
      //   buttonColor: indigoAccent,
      //   textTheme: ButtonTextTheme.primary,
      // ),
    );
  }
}
