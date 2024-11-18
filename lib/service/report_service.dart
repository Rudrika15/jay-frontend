import 'dart:convert';
import 'dart:io';

import 'package:flipcodeattendence/featuers/Admin/model/employee_report_model.dart';
import 'package:flipcodeattendence/service/shared_preferences_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:http/http.dart' as http;

import '../helper/api_helper.dart';
import '../theme/app_colors.dart';

class ReportService {
  Future<EmployeeReportModel?> employeeReport({required BuildContext context, required String startDate, required String endDate}) async {
    try {
      final token = await SharedPreferencesService.getUserToken();
      final response = await http.post(
        Uri.parse(ApiHelper.report),
        body: {
          'startDate': startDate,
          'endDate': endDate
        },
        headers: {'Authorization': 'Bearer $token'},
      );
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return EmployeeReportModel.fromJson(jsonDecode(response.body));
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
}