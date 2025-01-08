import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';

import '/helper/api_helper.dart';
import '/models/login_model.dart';
import '/service/shared_preferences_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../theme/app_colors.dart';

class LoginService {
  Future<bool> userLogin(
      {required String phone, required String password}) async {
    try {
      final response = await http.post(Uri.parse(ApiHelper.loginUrl),
          body: {'phone': phone, 'password': password});
      print("body=======");
      print(response.body);
      final data = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        await SharedPreferencesService.setUserMobileNo(
            mobileNo:
                LoginModel.fromJson(jsonDecode(response.body)).user?.phone ??
                    '');
        await SharedPreferencesService.setUserName(
            userName:
                LoginModel.fromJson(jsonDecode(response.body)).user?.name ??
                    '');
        await SharedPreferencesService.setUserToken(
            token: data['token'].toString());
        await SharedPreferencesService.setUserRole(
            role: data['role'][0].toString());
        return true;
      } else {
        Get.showSnackbar(
          GetSnackBar(
            title: "Error",
            message: data['message'].toString(),
            duration: Duration(seconds: 2),
            backgroundColor: AppColors.red,
            snackPosition: SnackPosition.BOTTOM,
          ),
        );
        return false;
      }
    } catch (e) {
      Get.showSnackbar(
        GetSnackBar(
          title: "Exception",
          message: e.toString(),
          duration: Duration(seconds: 2),
          backgroundColor: AppColors.red,
          snackPosition: SnackPosition.BOTTOM,
        ),
      );
      return false;
    }
  }

  Future<bool> changePassword(
      {required BuildContext context,
      required String oldPassword,
      required String newPassword}) async {
    try {
      final token = await SharedPreferencesService.getUserToken();
      final response = await http.post(
        Uri.parse(ApiHelper.changePasswordUrl),
        headers: {'Authorization': 'Bearer $token'},
        body: {
          "old_password": oldPassword,
          "new_password": newPassword
        },
      );
      print(response.statusCode);
      print(response.body);
      final data = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.showSnackbar(
          GetSnackBar(
            title: "Success",
            message: data['message'].toString(),
            duration: Duration(seconds: 2),
            backgroundColor: AppColors.green,
            snackPosition: SnackPosition.BOTTOM,
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
            snackPosition: SnackPosition.BOTTOM,
          ),
        );
        return false;
      }
    } catch (e) {
      Get.showSnackbar(
        GetSnackBar(
          title: "Exception",
          message: e.toString(),
          duration: Duration(seconds: 2),
          backgroundColor: AppColors.red,
          snackPosition: SnackPosition.BOTTOM,
        ),
      );
      return false;
    }
  }

  Future<void> updateToken() async {
    try {
      final token = await SharedPreferencesService.getUserToken();
      final fcmToken = await FirebaseMessaging.instance.getToken();
      final response = await http.post(
        Uri.parse(ApiHelper.updateToken),
        headers: {'Authorization': 'Bearer $token'},
        body: {"token": fcmToken},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        print(response.body);
        debugPrint("Token updated");
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
