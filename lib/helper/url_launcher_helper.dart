import 'package:url_launcher/url_launcher.dart';

import 'api_helper.dart';

class UrlLauncherHelper {
  static Future<bool> goToPlayStore() async {
    final apiHelper = ApiHelper();
    final appPlayStoreUrl = apiHelper.appPlayStoreUrl;
    if(await canLaunchUrl(Uri.parse(appPlayStoreUrl))) {
      await launchUrl(Uri.parse(appPlayStoreUrl));
      return true;
    } else {
      return false;
    }
  }
  
  static Future<bool> openTelephoneApp({required String url}) async {
    try {
      final bool launched = await launchUrl(Uri.parse(url));
      if(launched) {
        return true;
      } else {
        return false;
      }
    } catch(e) {
      print(e.toString());
      return false;
    }
  }
}