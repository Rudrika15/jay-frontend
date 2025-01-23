import 'dart:convert';

import 'package:flipcodeattendence/featuers/Admin/model/daily_attendence_model.dart';
import 'package:flipcodeattendence/helper/api_helper.dart';
import 'package:flipcodeattendence/service/rest_api_service.dart';
import 'package:flipcodeattendence/widget/common_widgets.dart';
import 'package:flutter/material.dart';

import '../featuers/Admin/model/AttendanceRecord.dart';
import '/service/attendance_service.dart';
import 'package:flutter/cupertino.dart';

class AttendanceProvider extends ChangeNotifier {
  AttendanceService attendanceService = AttendanceService();
  AttendanceRecord? _attendanceRecord = AttendanceRecord();

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  AttendanceRecord? get attendanceRecord => _attendanceRecord;

  Future<void> updateAttendanceData(BuildContext context,
      {required String type,
      required String userId,
      DateTime? date,
      TimeOfDay? time}) async {
    _isLoading = true;
    notifyListeners();
    await attendanceService.userAttendance(context,
        type: type, time: time, date: date, userId: userId);
    _isLoading = false;
    notifyListeners();
  }

  Future<AttendanceRecord?> showAttendanceRecord() async {
    _isLoading = true;
    _attendanceRecord = await attendanceService.attendanceRecord();
    _isLoading = false;
    notifyListeners();
    return _attendanceRecord;
  }

  DailyAttendanceModel? _dailyAttendanceModel;

  DailyAttendanceModel? get dailyAttendanceModel => _dailyAttendanceModel;
  List<DailyAttendanceData>? _dailyAttendanceList;

  List<DailyAttendanceData>? get dailyAttendanceList => _dailyAttendanceList;

  Future<void> getDailyAttendance({String? date}) async {
    _isLoading = true;
    _dailyAttendanceModel = await attendanceService.getDailyAttendance(date);
    _dailyAttendanceList = _dailyAttendanceModel?.data;
    _isLoading = false;
    notifyListeners();
  }

  List<DailyAttendanceData>? _staffList;

  List<DailyAttendanceData>? get staffList => _staffList;

  Future<void> getStaffList(BuildContext context) async {
    _isLoading = true;
    notifyListeners();
    final data = await attendanceService.getDailyAttendance(null);
    _staffList = data?.data;
    _isLoading = false;
    notifyListeners();
  }

  final service = RestApiService();
  Future<bool> createUser(BuildContext context, {required Map<String, String> userDetails}) async {
    _isLoading = true;
    notifyListeners();
    final api = ApiHelper.createUser;
    final body = userDetails;
    try {
      await service.invokeApi(url: api, requestType: HttpRequestType.post,body: jsonEncode(body));
      CommonWidgets.customSnackBar(context: context, title: "User created successfully");
      return true;
    } catch(e) {
      CommonWidgets.customSnackBar(context: context, title: e.toString());
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

}
