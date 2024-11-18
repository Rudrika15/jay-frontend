import 'package:flipcodeattendence/models/notification_response_model.dart';
import 'package:flipcodeattendence/service/notification_service.dart';
import 'package:flutter/material.dart';

class NotificationProvider with ChangeNotifier {
  final notificationService = NotificationService();

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
}
