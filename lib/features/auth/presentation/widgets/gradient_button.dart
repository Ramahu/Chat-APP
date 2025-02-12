import 'package:flutter/material.dart';
import '../../../../core/responsive_ui.dart';
import '../../../../core/util/colors.dart';

Widget defaultGradientBottom({
  required double width,
  required double height,
  required Color color1,
  required Color color2,
  required String text,
  required function,
  double radius = 35.0,
  required context ,
}) =>
    Container(
      alignment: Alignment.center,
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color1,
            color2,
          ],
        ),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: transparent,
          disabledForegroundColor: transparent,
          shadowColor: transparent,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius)),
        ),
        onPressed: function,
        child: Text(text, style:  TextStyle(color: white, fontSize: Responsive.textMultiplier(context) * 5 )),
      ),
    );