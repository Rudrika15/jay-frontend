import 'package:flipcodeattendence/helper/string_helper.dart';
import 'package:flipcodeattendence/helper/url_launcher_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/app_provider.dart';
import '../widget/dialog_widget.dart';
import 'api_helper.dart';
import 'method_helper.dart';

/// This class will check app version and show update dialog if update is
/// available.
class AppVersionChecker {
  final apiHelper = ApiHelper();

  Future<void> checkForAppUpdate(BuildContext context) async {
    final appVersion = apiHelper.appVersion;
    Provider.of<AppProvider>(context, listen: false)
        .getAppVersion()
        .then((value) {
      if (value != null) {
        final String? apiAppVersion = value.data?.version?.toString().trim();
        final int updateValue = value.data?.majorUpdate ?? 0;
        if (apiAppVersion != appVersion) {
          showAppUpdateDialog(updateValue: updateValue, context: context);
        }
      }
    });
  }

  showAppUpdateDialog(
      {required int updateValue, required BuildContext context}) async {
    await Future.delayed(const Duration(seconds: 1), () {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return UpdateAppDialogWidget(
                updateValue: updateValue,
                onTap: () async {
                  UrlLauncherHelper.goToPlayStore().then((value) {
                    if (!value) {
                      MethodHelper.showSnackBar(
                          message: StringHelper.errorLaunchUrl,
                          isSuccess: false);
                    }
                  });
                });
          });
    });
  }
}
