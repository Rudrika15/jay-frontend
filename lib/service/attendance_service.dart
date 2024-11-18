import 'dart:convert';
import 'dart:io';

import 'package:flipcodeattendence/featuers/Admin/model/daily_attendence_model.dart';
import 'package:flipcodeattendence/theme/app_colors.dart';
import 'package:get/get.dart';

import '../featuers/Admin/model/AttendanceRecord.dart';
import '/service/shared_preferences_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../helper/api_helper.dart';

class AttendanceService {
  Future<void> userAttendance(BuildContext context, String timekey) async {
    try {
      final token = await SharedPreferencesService.getUserToken();
      final response = await http.post(
        Uri.parse(ApiHelper.attendance),
        body: {
          'timekey': timekey,
          'time': DateFormat('HH:mm:ss').format(DateTime.now())
        },
        headers: {'Authorization': 'Bearer $token'},
      );
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        (kDebugMode) => print(response.body);
      } else {
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
      }
    }
    return null;
  }

  Future<AttendanceRecord?> attendanceRecord() async {
    try {
      final _token = await SharedPreferencesService.getUserToken();
      print(_token);
      final response = await http.get(
        Uri.parse(ApiHelper.showAttendance),
        headers: {
          'Authorization': 'Bearer $_token',
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        print(response.body);
        return AttendanceRecord.fromJson(jsonDecode(response.body));
      } else {
        return null;
      }
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  Future<DailyAttendenceModel?> getDailyAttedence(String? date) async {
    try {
      final _token = await SharedPreferencesService.getUserToken();
      print(_token);
      final response = await http.get(
        Uri.parse(
            ApiHelper.dailyAttendence + (date != null ? "?date=$date" : '')),
        headers: {
          'Authorization': 'Bearer $_token',
        },
      );
      print(ApiHelper.dailyAttendence + (date != null ? "?date=$date" : ''));
      print(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        print(response.body);
        return DailyAttendenceModel.fromJson(jsonDecode(response.body));
      } else {
        return null;
      }
    } catch (e) {
      print(e.toString());
    }
    return null;
  }
}
