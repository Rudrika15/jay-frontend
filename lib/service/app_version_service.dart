import 'dart:convert';

import 'package:flipcodeattendence/models/app_version_model.dart';
import 'package:http/http.dart' as http;
import 'package:flipcodeattendence/helper/api_helper.dart';
import 'package:flipcodeattendence/service/shared_preferences_service.dart';

class AppVersionService {
  Future<AppVersionModel?> getAppVersion() async {
    final api = ApiHelper.getAppVersion;
    final token = await SharedPreferencesService.getUserToken();
    final headers = {
      'Authorization' : 'Bearer $token'
    };

    try {
      final response = await http.get(Uri.parse(api), headers: headers);
      if(response.statusCode == 200 || response.statusCode == 201) {
        return AppVersionModel.fromJson(jsonDecode(response.body));
      } else {
        return null;
      }
    } catch(e) {
      print(e.toString());
      return null;
    }
  }
}