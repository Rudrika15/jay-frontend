import 'dart:convert';
import 'package:flipcodeattendence/helper/api_helper.dart';
import 'package:flipcodeattendence/models/notification_response_model.dart';
import 'package:flipcodeattendence/service/shared_preferences_service.dart';
import 'package:http/http.dart' as http;

class NotificationService {
  Future<NotificationResponseModel?> getNotifications() async {
    try {
      final _token = await SharedPreferencesService.getUserToken();
      final response = await http.get(
        Uri.parse(
          ApiHelper.notification,
        ),
        headers: {'Authorization': 'Bearer $_token'},
      );
      print(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return NotificationResponseModel.fromJson(jsonDecode(response.body));
      } else {
        return null;
      }
    } catch (e) {
      print(e.toString());
    }
    return null;
  }
}
