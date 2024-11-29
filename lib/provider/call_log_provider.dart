import 'dart:convert';

import 'package:flipcodeattendence/featuers/User/model/staff_allocated_call_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

import '../featuers/Admin/model/team_model.dart';
import '../helper/api_helper.dart';
import '../helper/enum_helper.dart';
import '../models/call_logs_model.dart';
import '../service/rest_api_service.dart';
import '../service/shared_preferences_service.dart';
import '../widget/common_widgets.dart';

class CallLogProvider extends ChangeNotifier {
  final apiService = RestApiService();
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  CallLogsModel? _callLogsModel = CallLogsModel();

  CallLogsModel? get callLogsModel => _callLogsModel;

  StaffAllocatedCallModel? _staffCallLogs;

  StaffAllocatedCallModel? get staffCallLogs => _staffCallLogs;

  List<StaffCallLogData> _allocatedStaffCallLogList = [];

  List<StaffCallLogData> get allocatedStaffCallLogList =>
      _allocatedStaffCallLogList;

  CallLog? _callLog = CallLog();

  CallLog? get callLog => _callLog;

  List<dynamic> _parts = [];

  List<dynamic> get parts => _parts;

  Future<void> getCallLogs(
      {CallStatusEnum status = CallStatusEnum.pending,
      required BuildContext context}) async {
    final url = ApiHelper.callLogList +
        '?status=${status.name.toString().toLowerCase()}';
    _isLoading = true;
    try {
      final response = await apiService.invokeApi(
          url: url, requestType: HttpRequestType.get);
      _callLogsModel = CallLogsModel.fromJson(jsonDecode(response.body));
    } catch (e) {
      CommonWidgets.customSnackBar(context: context, title: e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getStaffCallLogs(
      {required BuildContext context, String date = ''}) async {
    final url = (date.trim().isNotEmpty)
        ? ApiHelper.staffCallLogList + '?date=$date'
        : ApiHelper.staffCallLogList;
    _isLoading = true;
    try {
      final response = await apiService.invokeApi(
          url: url, requestType: HttpRequestType.get);
      _staffCallLogs =
          StaffAllocatedCallModel.fromJson(jsonDecode(response.body));
      _allocatedStaffCallLogList = [];
      final List<StaffCallLogData> callLogList = _staffCallLogs?.data ?? [];
      _allocatedStaffCallLogList = callLogList
          .where((element) =>
              element.call?.status?.trim().toLowerCase() ==
              CallStatusEnum.allocated.name.trim().toLowerCase())
          .toList();
    } catch (e) {
      CommonWidgets.customSnackBar(context: context, title: e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getCallLogDetail(
      {required String id, required BuildContext context}) async {
    final url = ApiHelper.getCallDetail + '/$id';
    _isLoading = true;
    try {
      final response = await apiService.invokeApi(
          url: url, requestType: HttpRequestType.get);
      final body = jsonDecode(response.body);
      _callLog = CallLog.fromJson(body['data']);
    } catch (e) {
      CommonWidgets.customSnackBar(context: context, title: e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> changeStatus(
      {required String id,
      required BuildContext context,
      required CallStatusEnum status}) async {
    final url = ApiHelper.changeStatus;
    final _body = {"id": id, "status": status.name.trim().toLowerCase()};
    _isLoading = true;
    try {
      final response = await apiService.invokeApi(
          url: url, body: jsonEncode(_body), requestType: HttpRequestType.get);
      final body = jsonDecode(response.body);
      CommonWidgets.customSnackBar(context: context, title: body['message']);
      return true;
    } catch (e) {
      CommonWidgets.customSnackBar(context: context, title: e.toString());
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> assignTask({
    required BuildContext context,
    required String timeSlot,
    required List<Members> members,
    required String charge,
    required String date,
    required String callId,
  }) async {
    final url = ApiHelper.assignTask;
    final parsedDate = DateFormat("dd-MM-yyyy").parse(date);
    final formattedDate = DateFormat("yyyy-MM-dd").format(parsedDate);
    final dynamic _body = {
      "userId": [members[0].userId!, members[1].userId!],
      "callId": callId,
      "date": formattedDate,
      "charge": charge,
      "slot": timeSlot
    };
    _isLoading = true;
    try {
      await apiService.invokeApi(
          url: url, body: jsonEncode(_body), requestType: HttpRequestType.post);
      CommonWidgets.customSnackBar(
          context: context, title: 'Task assigned successfully');
      return true;
    } catch (e) {
      CommonWidgets.customSnackBar(context: context, title: e.toString());
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getParts(BuildContext context) async {
    final url = ApiHelper.getParts;
    _isLoading = true;
    try {
      final response = await apiService.invokeApi(
          url: url, requestType: HttpRequestType.get);
      final decodedResponse = jsonDecode(response.body);
      final responseData = decodedResponse['data'];
      _parts = responseData;
      print(responseData);
    } catch (e) {
      CommonWidgets.customSnackBar(context: context, title: e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
