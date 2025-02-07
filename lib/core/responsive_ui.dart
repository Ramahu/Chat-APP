import 'package:flutter/widgets.dart';

class Responsive {
  static double width(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double height(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static double blockSize(BuildContext context) {
    return MediaQuery.of(context).size.width / 100;
  }

  static double textMultiplier(BuildContext context) {
    return MediaQuery.of(context).size.width / 100;
  }

  static double heightMultiplier(BuildContext context) {
    return MediaQuery.of(context).size.height / 100;
  }

  static bool isMobile(BuildContext context) {
    return width(context) < 600;
  }

  static bool isTablet(BuildContext context) {
    return width(context) >= 600 && width(context) < 1200;
  }

  static bool isDesktop(BuildContext context) {
    return width(context) >= 1200;
  }
}