import 'package:flutter/material.dart';

Size screenSize(BuildContext context) {
  return MediaQuery.of(context).size;
}

double screenWidth({required BuildContext context, double? divideBy}) {
  return screenSize(context).width / (divideBy ?? 1);
}

double screenHeight({required BuildContext context, double? divideBy}) {
  return screenSize(context).height / (divideBy ?? 1);
}