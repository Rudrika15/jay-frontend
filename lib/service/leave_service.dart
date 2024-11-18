import 'dart:convert';
import 'dart:io';

import 'package:flipcodeattendence/models/leave_requests_model.dart';
import 'package:get/get_connect/http/src/response/response.dart';

import '/models/leavelist_model.dart';
import '/service/shared_preferences_service.dart';
import '/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:http/http.dart' as http;

import '../helper/api_helper.dart';

class LeaveService {
  Future<bool> applyLeave(BuildContext context, dynamic body) async {
    try {
      final token = await SharedPreferencesService.getUserToken();
      final response = await http.post(Uri.parse(ApiHelper.applyLeave),
          body: body, headers: {'Authorization': 'Bearer $token'});
      print('leave');
      print(response.body);
      final data = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.showSnackbar(
          GetSnackBar(
            title: "Success",
            message: data['message'].toString(),
            duration: Duration(seconds: 2),
            backgroundColor: AppColors.green,
            snackPosition: SnackPosition.TOP,
          ),
        );
        return true;
      } else {
        Get.showSnackbar(
          GetSnackBar(
            title: "Error",
            message: data['message'].toString(),
            duration: Duration(seconds: 2),
            backgroundColor: AppColors.red,
            snackPosition: SnackPosition.TOP,
          ),
        );
        return false;
      }
    } catch (e) {
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
      } else {
        print(e);
        Get.showSnackbar(
          GetSnackBar(
            title: "Exception",
            message: e.toString(),
            duration: Duration(seconds: 2),
            backgroundColor: AppColors.red,
            snackPosition: SnackPosition.TOP,
          ),
        );
      }
      return false;
    }
  }

  Future<LeaveListModel?> leaveRecord() async {
    try {
      final _token = await SharedPreferencesService.getUserToken();
      final response = await http.get(Uri.parse(ApiHelper.showLeave),
          headers: {'Authorization': 'Bearer $_token'});
      if (response.statusCode == 200 || response.statusCode == 201) {
        return LeaveListModel.fromJson(jsonDecode(response.body));
      } else {
        return null;
      }
    } catch (e) {
      print(e.toString());
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

  Future<LeaveRequestsModel?> getLeaveRequestList(
      {String? page, bool getCurrentDateLeave = false}) async {
    try {
      final _token = await SharedPreferencesService.getUserToken();
      final response = await http.get(
          Uri.parse(
            (getCurrentDateLeave == true)
                ? ApiHelper.todayLeave + (page != null ? "?page=$page" : '')
                : ApiHelper.leaveApplications + (page != null ? "?page=$page" : ''),
          ),
          headers: {'Authorization': 'Bearer $_token'});
      print(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return LeaveRequestsModel.fromJson(jsonDecode(response.body));
      } else {
        return null;
      }
    } catch (e) {
      print(e.toString());
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

  Future<bool> leaveAction(BuildContext context, bool isApprove, String leaveId,
      String? leaveActionText) async {
    try {
      final token = await SharedPreferencesService.getUserToken();
      print(ApiHelper.leaveApproval + leaveId);
      print({
        "status": leaveActionText ?? (isApprove ? "Approved" : "Rejected"),
      });
      final response =
          await http.post(Uri.parse(ApiHelper.leaveApproval + leaveId), body: {
        "status": leaveActionText ?? (isApprove ? "Approved" : "Rejected"),
      }, headers: {
        'Authorization': 'Bearer $token'
      });
      print(response.body);
      // final data = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
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
      return false;
    }
  }

  Future<bool> cancelLeave(
    BuildContext context,
    String leaveId,
  ) async {
    try {
      final token = await SharedPreferencesService.getUserToken();
      print(ApiHelper.leaveCancel + leaveId);

      final response = await http.post(
          Uri.parse(ApiHelper.leaveCancel + leaveId),
          headers: {'Authorization': 'Bearer $token'});
      print('Leave Cancel');
      print(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
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
      return false;
    }
  }
}
