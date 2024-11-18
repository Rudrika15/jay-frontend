import 'dart:convert';

import '/models/show_attendance_model.dart';
import '/service/shared_preferences_service.dart';
import 'package:http/http.dart' as http;

import '../helper/api_helper.dart';

class ShowAttendanceService {
  Future<ShowAttendanceModel?> getShowAttendance() async {
    try {
      var token = await SharedPreferencesService.getUserToken();
      var response = await http.get(
        Uri.parse(ApiHelper.showAttendance),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return ShowAttendanceModel.fromJson(json.decode(response.body));
      } else {
        return null;
      }
    } catch (e) {
      print(e);
    }
    return null;
  }
}
