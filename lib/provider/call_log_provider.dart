import 'dart:convert';

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

  CallLog? _callLog = CallLog();

  CallLog? get callLog => _callLog;

  Future<void> getCallLogs(
      {CallStatusEnum status = CallStatusEnum.pending,
      required BuildContext context}) async {
    final url = ApiHelper.callLogList +
        '?status=${status.name.toString().toLowerCase()}';
    final token = await SharedPreferencesService.getUserToken();
    final header = {"Authorization": "Bearer $token"};
    _isLoading = true;
    try {
      final response = await apiService.invokeApi(
          url: url, header: header, requestType: HttpRequestType.get);
      _callLogsModel = CallLogsModel.fromJson(jsonDecode(response.body));
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
    final token = await SharedPreferencesService.getUserToken();
    final header = {"Authorization": "Bearer $token"};
    _isLoading = true;
    try {
      final response = await apiService.invokeApi(
          url: url, header: header, requestType: HttpRequestType.get);
      final body = jsonDecode(response.body);
      _callLog = CallLog.fromJson(body['data']);
    } catch (e) {
      CommonWidgets.customSnackBar(context: context, title: e.toString());
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
    final token = await SharedPreferencesService.getUserToken();
    final header = {"Authorization": "Bearer $token","Content-Type": "application/json"};
    final parsedDate = DateFormat("dd-MM-yyyy").parse(date);
    final formattedDate = DateFormat("yyyy-MM-dd").format(parsedDate);
    final dynamic _body = {
      "userId":[members[0].userId!, members[1].userId!],
      "callId":callId,
      "date":formattedDate,
      "charge":charge,
      "slot":timeSlot
    };
    _isLoading = true;
    try {
      await apiService.invokeApi(
          url: url, header: header,body: jsonEncode(_body), requestType: HttpRequestType.post);
      CommonWidgets.customSnackBar(context: context, title: 'Task assigned successfully');
      return true;
    } catch (e) {
      CommonWidgets.customSnackBar(context: context, title: e.toString());
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
