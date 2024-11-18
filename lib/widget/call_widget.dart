import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../helper/url_launcher_helper.dart';
import '../theme/app_colors.dart';

abstract class CallWidgetRaw extends StatelessWidget {
  final String? phoneNumber;

  const CallWidgetRaw({super.key, this.phoneNumber});

  @protected
  Widget buildWidget();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        bool result =
            await UrlLauncherHelper.openTelephoneApp(url: 'tel:$phoneNumber');
        if (result == false) {
          Get.showSnackbar(
            GetSnackBar(
              title: "Error",
              message: 'Cannot open contact app. Please try again later',
              duration: Duration(seconds: 2),
              backgroundColor: AppColors.red,
              snackPosition: SnackPosition.BOTTOM,
            ),
          );
        }
      },
      child: buildWidget(),
    );
  }
}

class CallWidget extends CallWidgetRaw {
  final String? phoneNumber;
  final Color iconColor;

  const CallWidget(
      {super.key, required this.phoneNumber, this.iconColor = AppColors.green})
      : super(phoneNumber: phoneNumber);

  @override
  Widget buildWidget() {
    return Icon(
      CupertinoIcons.phone,
      color: iconColor,
    );
  }
}

class CallWidgetSecond extends CallWidgetRaw {
  final String? phoneNumber;

  const CallWidgetSecond({super.key, this.phoneNumber})
      : super(phoneNumber: phoneNumber);

  @override
  Widget buildWidget() {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(
          10,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            CircleAvatar(
              radius: 15,
              backgroundColor: AppColors.green,
              child: Icon(
                CupertinoIcons.phone,
                size: 18,
                color: AppColors.onPrimaryLight,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              phoneNumber ?? '',
            ),
          ],
        ),
      ),
    );
  }
}
