import 'package:flutter/cupertino.dart';

class ResponsiveSize {
  static double height = 1920;
  static double width = 1080;
  static double aspectRatio = 1920 / 1080;
  static double bottomBarSize = 50;
  static double statusBarSize = 20;

  static void init(BuildContext context) {
    statusBarSize = MediaQuery.of(context).viewPadding.top;
    bottomBarSize = MediaQuery.of(context).viewPadding.bottom;
    height = MediaQuery.of(context).size.height - statusBarSize - bottomBarSize;
    width = MediaQuery.of(context).size.width;
  }

  // static height(BuildContext context) {
  //   return MediaQuery.of(context).size.height -
  //       MediaQuery.of(context).viewPadding.top;
  // }

  // static width(BuildContext context) {
  //   return MediaQuery.of(context).size.width;
  // }

  // static aspectRatio(BuildContext context) {
  //   return MediaQuery.of(context).size.aspectRatio;
  // }

  // static statusBarSize(BuildContext context) {
  //   return MediaQuery.of(context).viewPadding.top;
  // }

  // static bottomBarSize(BuildContext context) {
  //   return MediaQuery.of(context).viewPadding.bottom;
  // }
}
