import 'package:flutter/material.dart';

import '../theme/app_colors.dart';


class CommonWidgets {
  static customSnackBar(
      {required BuildContext context,
      required String title,
      Color? color,
      bool? isError}) {
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          elevation: 0,
          duration: const Duration(seconds: 2),
          content: Text(title,
              style: const TextStyle(
                color: AppColors.onPrimaryLight,
                fontWeight: FontWeight.bold,
              )),
          backgroundColor: color ??
              (isError == true ? AppColors.red : AppColors.aPrimary),
        ),
      );
  }
}
