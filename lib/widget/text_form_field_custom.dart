import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_colors.dart';

class TextFormFieldWidget extends StatefulWidget {
  static const _defaultEnabled = true;
  static const _defaultAutofocused = false;
  static const _defaultReadOnly = false;
  static const _defaultObscureText = false;
  static const _defaultMaxLines = 1;

  final TextInputType? keyboardType;
  final void Function()? onTap;
  final bool? isFilled;
  final int? maxLength;
  final Color? fillColor;
  final TextStyle? textStyle;
  final String? hintText;
  final String? labelText;
  final TextStyle? hintTextStyle;
  final TextStyle? labelTextStyle;
  final Widget? prefixWidget;
  final String? Function(String?)? validator;
  final Function(String?)? onSaved;
  final List<TextInputFormatter>? inputFormatters;
  final TextEditingController? controller;
  final bool readOnly, enabled, obscureText, isFocused;
  final Widget? suffixIcon;
  final int maxLines;
  final Color? borderColor;
  final void Function(String)? onChanged;

  const TextFormFieldWidget(
      {super.key,
      this.keyboardType,
      this.maxLength,
      this.textStyle,
      this.hintText,
      this.hintTextStyle,
      this.prefixWidget,
      this.onTap,
      this.isFocused = _defaultAutofocused,
      this.validator,
      this.onSaved,
      this.inputFormatters,
      required this.controller,
      this.readOnly = _defaultReadOnly,
      this.enabled = _defaultEnabled,
      this.labelText,
      this.labelTextStyle,
      this.isFilled,
      this.fillColor,
      this.obscureText = _defaultObscureText,
      this.suffixIcon,
      this.maxLines = _defaultMaxLines,
      this.borderColor,
      this.onChanged});

  @override
  State<TextFormFieldWidget> createState() => _TextFormFieldCustomState();
}

class _TextFormFieldCustomState extends State<TextFormFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: widget.onTap,
      obscureText: widget.obscureText,
      autofocus: widget.isFocused,
      enabled: widget.enabled,
      maxLines: widget.maxLines,
      readOnly: widget.readOnly,
      controller: widget.controller,
      onSaved: widget.onSaved,
      validator: widget.validator,
      onChanged: widget.onChanged,
      inputFormatters: widget.inputFormatters,
      keyboardType: widget.keyboardType,
      maxLength: widget.maxLength,
      style: widget.textStyle,
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus!.unfocus();
      },

      decoration: InputDecoration(
        alignLabelWithHint: true,
        filled: widget.isFilled,
        fillColor: widget.fillColor,
        enabled: true,
        hintText: widget.hintText,
        hintStyle: widget.hintTextStyle,
        prefixIcon: widget.prefixWidget,
        labelText: widget.labelText,
        labelStyle: widget.labelTextStyle,
        suffixIcon: widget.suffixIcon,
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: widget.borderColor ?? AppColors.grey,
            )),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
                color: widget.borderColor ?? AppColors.grey,
                width: 1.5)),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
                color: widget.borderColor ?? AppColors.red)),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
                color: widget.borderColor ?? AppColors.red,
                width: 1.5)),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
              color: widget.borderColor ?? AppColors.grey, width: 1.5),
        ),
      ),
    );
  }
}

