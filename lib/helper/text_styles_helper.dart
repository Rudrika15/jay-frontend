import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class TextStyleCustom {
  static TextTheme textTheme() {
    return TextTheme(
      displayLarge: TextStyle(fontSize: 57, color: AppColors.onPrimaryLight),
      displayMedium: TextStyle(fontSize: 45, color: AppColors.onPrimaryLight),
      displaySmall: TextStyle(fontSize: 36, color: AppColors.onPrimaryLight),
      headlineLarge: TextStyle(fontSize: 32, color: AppColors.onPrimaryLight),
      headlineMedium: TextStyle(fontSize: 28, color: AppColors.onPrimaryLight),
      headlineSmall: TextStyle(fontSize: 24, color: AppColors.onPrimaryLight),
      titleLarge: TextStyle(fontSize: 22, color: AppColors.onPrimaryLight),
      titleMedium: TextStyle(fontSize: 16, color: AppColors.onPrimaryLight),
      titleSmall: TextStyle(fontSize: 14, color: AppColors.onPrimaryLight),
      labelLarge: TextStyle(fontSize: 14, color: AppColors.onPrimaryLight),
      labelMedium: TextStyle(fontSize: 12, color: AppColors.onPrimaryLight),
      labelSmall: TextStyle(fontSize: 11, color: AppColors.onPrimaryLight),
      bodyLarge: TextStyle(fontSize: 16, color: AppColors.onPrimaryLight),
      bodyMedium: TextStyle(fontSize: 14, color: AppColors.onPrimaryLight),
      bodySmall: TextStyle(fontSize: 12, color: AppColors.onPrimaryLight),
    );
  }
  
  static TextTheme textThemeDark() {
    return TextTheme(
      displayLarge: TextStyle(fontSize: 57, color: AppColors.onPrimaryBlack),
      displayMedium: TextStyle(fontSize: 45, color: AppColors.onPrimaryBlack),
      displaySmall: TextStyle(fontSize: 36, color: AppColors.onPrimaryBlack),
      headlineLarge: TextStyle(fontSize: 32, color: AppColors.onPrimaryBlack),
      headlineMedium: TextStyle(fontSize: 28, color: AppColors.onPrimaryBlack),
      headlineSmall: TextStyle(fontSize: 24, color: AppColors.onPrimaryBlack),
      titleLarge: TextStyle(fontSize: 22, color: AppColors.onPrimaryBlack),
      titleMedium: TextStyle(fontSize: 16, color: AppColors.onPrimaryBlack),
      titleSmall: TextStyle(fontSize: 14, color: AppColors.onPrimaryBlack),
      labelLarge: TextStyle(fontSize: 14, color: AppColors.onPrimaryBlack),
      labelMedium: TextStyle(fontSize: 12, color: AppColors.onPrimaryBlack),
      labelSmall: TextStyle(fontSize: 11, color: AppColors.onPrimaryBlack),
      bodyLarge: TextStyle(fontSize: 16, color: AppColors.onPrimaryBlack),
      bodyMedium: TextStyle(fontSize: 14, color: AppColors.onPrimaryBlack),
      bodySmall: TextStyle(fontSize: 12, color: AppColors.onPrimaryBlack),
    ); 
  }
}
