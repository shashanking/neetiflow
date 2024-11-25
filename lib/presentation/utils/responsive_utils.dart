import 'package:flutter/material.dart';

class ResponsiveUtils {
  static bool isSmallScreen(BuildContext context) => MediaQuery.of(context).size.width < 600;
  static bool isMediumScreen(BuildContext context) => MediaQuery.of(context).size.width < 1200;
  static bool isLargeScreen(BuildContext context) => MediaQuery.of(context).size.width >= 1200;

  static double getPadding(BuildContext context) {
    if (isSmallScreen(context)) return 16.0;
    if (isMediumScreen(context)) return 24.0;
    return 32.0;
  }

  static double getCardAspectRatio(BuildContext context) {
    if (isSmallScreen(context)) return 2.5;
    if (isMediumScreen(context)) return 1.8;
    return 1.5;
  }

  static int getGridCrossAxisCount(BuildContext context) {
    if (isSmallScreen(context)) return 1;
    if (isMediumScreen(context)) return 2;
    return 4;
  }
}
