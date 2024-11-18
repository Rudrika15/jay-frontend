import 'package:flipcodeattendence/mixins/navigator_mixin.dart';
import 'package:flipcodeattendence/theme/app_colors.dart';
import 'package:flipcodeattendence/widget/custom_elevated_button.dart';
import 'package:flipcodeattendence/widget/dialog_widget.dart';
import 'package:flutter/material.dart';

class CustomAlertWidget extends StatelessWidget with NavigatorMixin {
  final String alertText;
  final IconData icon;
  final Color? iconColor;
  final void Function()? onActionButtonPressed;
  const CustomAlertWidget(
      {super.key,
      required this.alertText,
      this.onActionButtonPressed,
      required this.icon,
      this.iconColor});

  @override
  Widget build(BuildContext context) {
    return DialogWidget(
      onPressed: () {},
      iconColor: iconColor ?? AppColors.onPrimaryBlack,
      buttonText: '',
      icon: icon,
      text: alertText,
      context: context,
      action: Row(
        children: [
          Expanded(
            child: CustomElevatedButton(
              onPressed: onActionButtonPressed,
              // backgroundColor: AppColors.aPrimary,
              buttonText: 'Yes',
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                ),
              ),
            ),
          ),
          Expanded(
            child: CustomElevatedButton(
              onPressed: () {
                pop(context);
              },
              backgroundColor: AppColors.grey,
              buttonText: 'No',
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
