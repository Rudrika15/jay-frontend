import 'package:flipcodeattendence/featuers/Admin/model/daily_attendence_model.dart';
import 'package:flipcodeattendence/featuers/Admin/model/employee_report_model.dart';
import 'package:flipcodeattendence/service/report_service.dart';

import '../featuers/Admin/model/AttendanceRecord.dart';
import '/service/attendance_service.dart';
import 'package:flutter/cupertino.dart';

class ReportProvider extends ChangeNotifier {
  final service = ReportService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  EmployeeReportModel? _employeeReportModel = EmployeeReportModel();
  EmployeeReportModel? get employeeReportModel => _employeeReportModel;

  Future<void> employeeReport({required BuildContext context, required String startDate, required String endDate}) async {
    _isLoading = true;
    _employeeReportModel = await service.employeeReport(context: context, startDate: startDate, endDate: endDate);
    _isLoading = false;
    notifyListeners();
  }

  Future<void> clearData() async{
    _employeeReportModel = null;
    notifyListeners();
  }
}
