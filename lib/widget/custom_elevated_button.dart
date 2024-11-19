import 'package:flipcodeattendence/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final String buttonText;
  final Color? backgroundColor;
  final Color? forgroundColor;
  final void Function()? onPressed;
  final OutlinedBorder? shape;
  final Size? size;
  final TextStyle? textStyle;
  const CustomElevatedButton(
      {super.key,
      required this.buttonText,
      this.onPressed,
      this.backgroundColor,
      this.forgroundColor,
      this.shape,
      this.size,
      this.textStyle});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor,
            foregroundColor: forgroundColor,
            fixedSize: size,
            shape: shape ??
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap),
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0),
          child: Text(
            buttonText,
            style: textStyle ??
                Theme.of(context).textTheme.labelLarge!.copyWith(
                    color: forgroundColor ?? AppColors.onPrimaryLight),
          ),
        ));
  }
}


