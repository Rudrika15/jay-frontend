import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static Future<SharedPreferences> getInstance() async {
    return await SharedPreferences.getInstance();
  }

  static Future<void> setUserToken({required String token}) async {
    final pref = await getInstance();
    await pref.setString('UserToken', token);
  }

  static Future<String?> getUserToken() async {
    final pref = await getInstance();
    return await pref.getString('UserToken');
  }

  static Future<void> setUserMobileNo({required String mobileNo}) async {
    final prefs = await getInstance();
    await prefs.setString('MobileNo', mobileNo);
  }

  static Future<String?> getUserMobileNo() async {
    final prefs = await getInstance();
    return prefs.getString('MobileNo');
  }

  static Future<void> setUserName({required String userName}) async {
    final prefs = await getInstance();
    await prefs.setString('userName', userName);
  }

  static Future<String?> getUserName() async {
    final prefs = await getInstance();
    return prefs.getString('userName');
  }

  static Future<void> setUserRole({required String role}) async {
    final prefs = await getInstance();
    await prefs.setString('userRole', role);
  }

  static Future<String?> getUserRole() async {
    final prefs = await getInstance();
    return prefs.getString('userRole');
  }

  static Future<void> clearUserData() async {
    final prefs = await getInstance();
    await prefs.clear();
  }

  static Future<void> setElapsedTime({required String time}) async {
    final prefs = await getInstance();
    await prefs.setString('elapsedTime', time);
  }

  static Future<String?> getElapsedTime() async {
    final prefs = await getInstance();
    return await prefs.getString('elapsedTime');
  }

  static Future<void> clearElapsedTime() async {
    final prefs = await getInstance();
    await prefs.remove('elapsedTime');
  }
}

