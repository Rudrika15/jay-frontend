import 'package:flipcodeattendence/service/shared_preferences_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

import '/service/login_service.dart';

class LoginProvider extends ChangeNotifier {
  LoginService loginService = LoginService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<bool> getUserToken(
      {required String phone, required String password}) async {
    _isLoading = true;
    notifyListeners();

    final value =
        await loginService.userLogin(phone: phone, password: password);

    _isLoading = false;
    notifyListeners();

    return value;
  }

  Future<bool> changePassword(
      {required BuildContext context,
      required String oldPassword,
      required String newPassword}) async {
    _isLoading = true;
    notifyListeners();

    final value = await loginService.changePassword(
        context: context, oldPassword: oldPassword, newPassword: newPassword);

    _isLoading = false;
    notifyListeners();

    return value;
  }

  String? _userRole;
  String? get userRole => _userRole;
  Future<void> updateToken() async {
    await loginService.updateToken();
  }

  Future<String?> getUserRole() async {
    _isLoading = true;
    _userRole = await SharedPreferencesService.getUserRole();
    _isLoading = false;
    notifyListeners();
    return _userRole;
  }
}
