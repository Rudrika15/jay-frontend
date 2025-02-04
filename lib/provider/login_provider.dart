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

  bool isAdmin = false;
  bool isUser = false;
  bool isClient = false;

  Future<bool> getUserToken(
      {required String phone, required String password}) async {
    _isLoading = true;
    notifyListeners();
    final value =
        await loginService.userLogin(phone: phone, password: password);
    await setUserRole();
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

  changeStatus({required bool isAdmin, required bool isUser, required bool isClient}) {
    this.isAdmin = isAdmin;
    this.isUser = isUser;
    this.isClient = isClient;
  }

  Future<void> setUserRole() async {
    _userRole = await SharedPreferencesService.getUserRole();
    final userRole = _userRole;
    if(userRole != null) {
      if(userRole.trim().toLowerCase() == UserRole.admin.name.toLowerCase()) {
        changeStatus(isAdmin: true, isUser: false, isClient: false);
      } else if(userRole.trim().toLowerCase() == UserRole.user.name.toLowerCase()) {
        changeStatus(isAdmin: false, isUser: true, isClient: false);
      } else {
        changeStatus(isAdmin: false, isUser: false, isClient: true);
      }
    }
    notifyListeners();
  }
}
