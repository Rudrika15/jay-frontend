import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../helper/string_helper.dart';
import '../theme/app_colors.dart';

class DialogWidget extends StatelessWidget {
  static const _defaultIconColor = AppColors.red;
  final IconData icon;
  final Color iconColor;
  final String text, buttonText;
  final void Function()? onPressed;
  final Widget? action;
  final BuildContext context;
  final bool willPop;
  const DialogWidget({
    super.key,
    required this.icon,
    required this.text,
    required this.buttonText,
    required this.onPressed,
    required this.context,
    this.action,
    this.iconColor = _defaultIconColor,
    this.willPop = true,
  });

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => willPop,
      child: Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 20,
            ),
            Icon(icon, size: 30, color: iconColor),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            action ??
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(10),
                                      bottomLeft: Radius.circular(10))),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                          onPressed: onPressed,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15.0),
                            child: Text(
                              buttonText,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(color: AppColors.onPrimaryLight),
                            ),
                          )),
                    ),
                  ],
                ),
          ],
        ),
      ),
    );
  }
}

class UpdateAppDialogWidget extends StatelessWidget {
  final int updateValue;
  final void Function()? onTap;
  const UpdateAppDialogWidget(
      {super.key, required this.updateValue, this.onTap});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => (updateValue == 0) ? true : false,
      child: Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Offstage(
                    offstage: (updateValue == 1),
                    child: IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: Icon(
                          Icons.close,
                          size: 25,
                        )))
              ],
            ),
            Offstage(
              offstage: (updateValue == 0),
              child: SizedBox(
                height: 20,
              ),
            ),
            Icon(CupertinoIcons.bell, size: 40, color: AppColors.aPrimary),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
              child: Text(
                StringHelper.newAppVersionAvailable,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(10),
                                  bottomLeft: Radius.circular(10))),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                      onPressed: onTap,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                        child: Text(
                          StringHelper.update,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(color: AppColors.onPrimaryLight),
                        ),
                      )),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
