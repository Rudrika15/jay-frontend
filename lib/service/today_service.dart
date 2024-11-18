import 'dart:convert';
import 'dart:io';

import 'package:flipcodeattendence/theme/app_colors.dart';
import 'package:get/get.dart';

import '/helper/api_helper.dart';
import '/models/today.dart';
import '/service/shared_preferences_service.dart';
import 'package:http/http.dart' as http;

class TodayService {
  Future<TodayModel?> getuserToday() async {
    try {
      final token = await SharedPreferencesService.getUserToken();
      print(token);
      var response = await http.get(
        Uri.parse(ApiHelper.today),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      // print(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        print(response.statusCode);
        print(response.body);
        return TodayModel.fromJson(json.decode(response.body));
      } else {
        print(response.statusCode);
        return null;
      }
    } catch (e) {
      (kDebugMode) => print(e.toString());
      if (e is SocketException) {
        Get.showSnackbar(
          GetSnackBar(
            title: "Connection Error",
            message: 'No internet connection.',
            duration: Duration(seconds: 2),
            backgroundColor: AppColors.red,
            snackPosition: SnackPosition.BOTTOM,
          ),
        );
        return null;
      }
      return null;
    }
  }
}
