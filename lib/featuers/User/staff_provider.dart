import 'dart:convert';

import 'package:flutter/cupertino.dart';

import '../../helper/api_helper.dart';
import '../../service/rest_api_service.dart';
import '../../widget/common_widgets.dart';

class StaffProvider extends ChangeNotifier {
  final apiService = RestApiService();
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  List<dynamic> _qrCodes = [];
  List<dynamic> get qrCodes => _qrCodes;

  Future<void> getQRCodeList(BuildContext context) async {
    final url = ApiHelper.qrList;
    _isLoading = true;
    try {
      final response = await apiService.invokeApi(
          url: url, requestType: HttpRequestType.get);
      final decodedBody = jsonDecode(response.body);
      _qrCodes = decodedBody['data'];
    } catch (e) {
      CommonWidgets.customSnackBar(context: context, title: e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}