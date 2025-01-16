import '/helper/text_styles_helper.dart';
import '/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData appThemeData() {
    return ThemeData(
        useMaterial3: true,
        fontFamily: 'Poppins',
        scaffoldBackgroundColor: AppColors.backgroundLight,
        canvasColor: AppColors.backgroundLight,
        popupMenuTheme: PopupMenuThemeData(
          color: AppColors.onPrimaryLight,
        ),
        bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: AppColors.onPrimaryLight
        ),
        chipTheme: ChipThemeData(
          backgroundColor: AppColors.backgroundLight,
          showCheckmark: false,
          selectedColor: AppColors.aPrimary,
        ),
        colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.aPrimary, primary: AppColors.aPrimary),
        datePickerTheme: DatePickerThemeData(
          backgroundColor: AppColors.onPrimaryLight,
          dividerColor: AppColors.aPrimary,
        ),
        dividerTheme: DividerThemeData(
          color: AppColors.onPrimaryBlack,
        ),
        textTheme: TextStyleCustom.textThemeDark(),
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                backgroundColor: AppColors.aPrimary,
                foregroundColor: AppColors.onPrimaryLight,
                iconColor: AppColors.onPrimaryLight,
                textStyle: TextStyle(fontWeight: FontWeight.bold))),
        expansionTileTheme: ExpansionTileThemeData(
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: Colors.transparent
            )
          )
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: AppColors.aPrimary,
          foregroundColor: AppColors.onPrimaryLight,
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: AppColors.backgroundLight,
          indicatorColor: AppColors.aPrimary,
          surfaceTintColor: AppColors.backgroundLight,
          iconTheme: WidgetStateProperty.resolveWith((Set<WidgetState> states) {
            if (states.contains(WidgetState.selected)) {
              return IconThemeData(
                color: AppColors.onPrimaryLight,
              );
            } else {
              return IconThemeData(
                color: AppColors.onPrimaryBlack,
              );
            }
          }),
          labelTextStyle:
              WidgetStateProperty.resolveWith((Set<WidgetState> states) {
            if (states.contains(WidgetState.selected)) {
              return TextStyle(color: AppColors.onPrimaryBlack);
            } else {
              return TextStyle(color: AppColors.onPrimaryBlack);
            }
          }),
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        ),
        dialogTheme: DialogTheme(
            backgroundColor: AppColors.backgroundLight,
            iconColor: AppColors.onPrimaryBlack,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10))),
        appBarTheme: AppBarTheme(
          elevation: 0,
          backgroundColor: AppColors.backgroundLight,
          foregroundColor: AppColors.onPrimaryBlack,
          surfaceTintColor: AppColors.onPrimaryLight,
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: AppColors.aPrimary,
          contentTextStyle: TextStyle(color: AppColors.onPrimaryLight),
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          closeIconColor: AppColors.onPrimaryLight,
          showCloseIcon: true,
        ),
      timePickerTheme: TimePickerThemeData(
        backgroundColor: AppColors.backgroundLight,
        dialBackgroundColor: AppColors.backgroundBlack.withOpacity(0.1),
        hourMinuteColor: AppColors.backgroundBlack.withOpacity(0.1)
      )
    );
  }
}
