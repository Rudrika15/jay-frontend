import 'package:flipcodeattendence/helper/api_helper.dart';
import 'package:flipcodeattendence/helper/method_helper.dart';
import 'package:flipcodeattendence/models/notification_response_model.dart';
import 'package:flipcodeattendence/service/notification_service.dart';
import 'package:flipcodeattendence/service/rest_api_service.dart';
import 'package:flutter/material.dart';

class NotificationProvider with ChangeNotifier {
  final notificationService = NotificationService();
  final service = RestApiService();
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  NotificationResponseModel? _notificationResponseModel;

  NotificationResponseModel? get notificationResponseModel =>
      _notificationResponseModel;

  Future<void> getNotification(BuildContext context) async {
    _isLoading = true;

    _notificationResponseModel = await notificationService.getNotifications();

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> deleteNotification(BuildContext context,
      {required String id}) async {
    _isLoading = true;
    notifyListeners();
    try {
      await service.invokeApi(
          url: "${ApiHelper.deleteNotification}/$id", requestType: HttpRequestType.post);
      return true;
    } catch (e) {
      MethodHelper.showSnackBar(message: e.toString());
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
