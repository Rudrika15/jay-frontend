import 'package:flutter/material.dart';

class CustomOutlinedButton extends StatelessWidget {
  final String buttonText;
  final void Function()? onPressed;
  final OutlinedBorder? shape;
  final Size? size;
  const CustomOutlinedButton(
      {super.key,
        required this.buttonText,
        this.onPressed,
        this.shape,
        this.size,});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
        style: OutlinedButton.styleFrom(
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
          ),
        ));
  }
}