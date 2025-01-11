import 'package:flutter/material.dart';

class AppColors {
  static const appLogoColor = Color(0xffFF6600);
  static const aPrimary = Colors.black;
  static const secondary = Colors.grey;
  static const onPrimaryLight = Colors.white;
  static const onPrimaryBlack = Colors.black;
  static const backgroundLight = Colors.white;
  static const backgroundBlack = Colors.black;
  static const grey = Colors.grey;
  static const red = Colors.red;
  static const green = Colors.green;
}

ColorScheme colorScheme(BuildContext context) {
  return Theme.of(context).colorScheme;
}
