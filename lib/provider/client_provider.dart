import 'dart:convert';
import 'dart:io';

import 'package:flipcodeattendence/helper/api_helper.dart';
import 'package:flipcodeattendence/models/call_logs_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../featuers/Admin/model/clients_model.dart';
import '../service/rest_api_service.dart';
import '../service/shared_preferences_service.dart';
import '../widget/common_widgets.dart';

class ClientProvider extends ChangeNotifier {
  final apiService = RestApiService();
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  ClientModel? _clientModel = ClientModel();

  ClientModel? get clientModel => _clientModel;

  CallLogsModel? _callLogsModel = CallLogsModel();
  CallLogsModel? get callLogsModel => _callLogsModel;

  Future<void> getClients(
      {String name = "", required BuildContext context}) async {
    final url = ApiHelper.getClients +
        (name.trim().isNotEmpty ? '?name=$name' : '?name=');
    final token = await SharedPreferencesService.getUserToken();
    final header = {"Authorization": "Bearer $token"};
    _isLoading = true;
    if (name.trim().isNotEmpty) {
      notifyListeners();
    }
    try {
      final response = await apiService.invokeApi(
          url: url, header: header, requestType: HttpRequestType.get);
      _clientModel = ClientModel.fromJson(jsonDecode(response.body));
    } catch (e) {
      CommonWidgets.customSnackBar(context: context, title: e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createCall(
      {required BuildContext context,
      required String description,
      required String date,
      required String address,
      String? client_id,
      File? photo}) async {
    final url = ApiHelper.createCall;
    final token = await SharedPreferencesService.getUserToken();
    final header = {"Authorization": "Bearer $token"};
    final request = await http.MultipartRequest('POST', Uri.parse(url));
    request.headers.addAll(header);
    request.fields['description'] = description;
    request.fields['address'] = address;
    request.fields['date'] = date;
    if (client_id != null) {
      request.fields['client_id'] = client_id;
    }
    if (photo != null) {
      request.files.add(await http.MultipartFile.fromPath('photo', photo.path));
    }
    _isLoading = true;
    try {
      final response = await request.send();
      final data = await http.Response.fromStream(response);
      final body = jsonDecode(data.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (body['status'] == true) {
          CommonWidgets.customSnackBar(context: context, title: body['message']);
          return true;
        } else {
          CommonWidgets.customSnackBar(
              context: context, title: body['message']);
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      CommonWidgets.customSnackBar(context: context, title: e.toString());
      print(e);
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
