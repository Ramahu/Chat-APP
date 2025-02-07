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
