import '/models/show_attendance_model.dart';
import '/service/show_attendance_service.dart';
import 'package:flutter/cupertino.dart';

class ShowAttendanceProvider extends ChangeNotifier {
  ShowAttendanceService showAttendanceService = ShowAttendanceService();
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  ShowAttendanceModel? _attendanceModel;

  ShowAttendanceModel? get todayData => _attendanceModel;

  Future<ShowAttendanceModel?> getShoeAttendanceService() async {
    _isLoading = true;
    _attendanceModel = await showAttendanceService.getShowAttendance();
    _isLoading = false;
    notifyListeners();
    return _attendanceModel;
  }
}
