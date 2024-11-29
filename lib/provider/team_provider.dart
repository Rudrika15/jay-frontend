import 'dart:convert';

import 'package:flipcodeattendence/featuers/Admin/model/team_model.dart';
import 'package:flutter/cupertino.dart';

import '../helper/api_helper.dart';
import '../service/rest_api_service.dart';
import '../service/shared_preferences_service.dart';
import '../widget/common_widgets.dart';

class TeamProvider extends ChangeNotifier {
  final apiService = RestApiService();
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  TeamModel? _teamModel = TeamModel();
  TeamModel? get teamModel => _teamModel;

  Future<void> getTeams(BuildContext context) async {
    final url = ApiHelper.teamList;
    _isLoading = true;
    try {
      final response = await apiService.invokeApi(
          url: url, requestType: HttpRequestType.get);
      _teamModel = TeamModel.fromJson(jsonDecode(response.body));
    } catch (e) {
      CommonWidgets.customSnackBar(context: context, title: e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}