import 'package:flipcodeattendence/helper/enum_helper.dart';
import 'package:flipcodeattendence/service/shared_preferences_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

import '/service/login_service.dart';

class LoginProvider extends ChangeNotifier {
  LoginService loginService = LoginService();
  String? _userRole;
  String? get userRole => _userRole;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<bool> getUserToken(
      {required String phone, required String password}) async {
    _isLoading = true;
    notifyListeners();
    final value =
        await loginService.userLogin(phone: phone, password: password);
    setUserRole();
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

  // Future<void> updateToken() async {
  //   await loginService.updateToken();
  // }

  Future<String?> getUserRole() async {
    _isLoading = true;
    _userRole = await SharedPreferencesService.getUserRole();
    _isLoading = false;
    notifyListeners();
    return _userRole;
  }

  bool isAdmin = false;
  bool isStaff = false;
  bool isClient = false;

  changeStatus({required bool isAdmin, required bool isStaff, required bool isClient}) {
    isAdmin = isAdmin;
    isStaff = isStaff;
    isClient = isClient;
  }

  Future<void> setUserRole() async {
    _userRole = await SharedPreferencesService.getUserRole();
    final userRole = _userRole;
    if(userRole != null) {
      if(userRole.trim().toLowerCase() == UserRole.admin.name.toLowerCase()) {
        changeStatus(isAdmin: true, isStaff: false, isClient: false);
      } else if(userRole.trim().toLowerCase() == UserRole.staff.name.toLowerCase()) {
        changeStatus(isAdmin: false, isStaff: true, isClient: false);
      } else {
        changeStatus(isAdmin: false, isStaff: false, isClient: true);
      }
    }
    notifyListeners();
  }
}
