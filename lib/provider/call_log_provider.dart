import 'dart:convert';

import 'package:flutter/cupertino.dart';

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

  Future<void> getCallLogs(
      {CallStatusEnum status = CallStatusEnum.pending, required BuildContext context}) async {
    final url = ApiHelper.callLogList + '?status=${status.name.toString().toLowerCase()}';
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
}