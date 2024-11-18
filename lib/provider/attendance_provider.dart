import 'package:flipcodeattendence/models/daily_attendence_model.dart';

import '/models/AttendanceRecord.dart';
import '/service/attendance_service.dart';
import 'package:flutter/cupertino.dart';

class AttendanceProvider extends ChangeNotifier {
  AttendanceService attendanceService = AttendanceService();
  AttendanceRecord? _attendanceRecord = AttendanceRecord();

  bool _isLoading = false;

  bool get isLoading => _isLoading;
  AttendanceRecord? get attendanceRecord => _attendanceRecord;

  Future<void> addData(BuildContext context, String timekey) async {
    _isLoading = true;
    notifyListeners();
    await attendanceService.userAttendance(context, timekey);
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

  DailyAttendenceModel? _dailyAttendenceModel;
  DailyAttendenceModel? get dailyAttendenceModel => _dailyAttendenceModel;
  List<DailyAttendenceData>? _dailyAttendanceList;
  List<DailyAttendenceData>? get dailyAttendanceList => _dailyAttendanceList;

  Future<void> getDailyAttendence({String? date}) async {
    _isLoading = true;
    _dailyAttendenceModel = await attendanceService.getDailyAttedence(date);
    _dailyAttendanceList = _dailyAttendenceModel?.dailyAttendenceData;
    _isLoading = false;
    notifyListeners();
  }

  void searchEmployee(String? searchText) {
    if (searchText != null) {
      _dailyAttendanceList = _dailyAttendenceModel?.dailyAttendenceData
          ?.where((element) =>
              element.user?.name?.toLowerCase().contains(searchText) ?? false)
          .toList();
    } else {
      _dailyAttendanceList = _dailyAttendenceModel?.dailyAttendenceData;
    }
    notifyListeners();
  }
}
