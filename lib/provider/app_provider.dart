import 'package:flipcodeattendence/models/app_version_model.dart';
import 'package:flipcodeattendence/service/app_version_service.dart';
import 'package:flutter/cupertino.dart';

class AppProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  AppVersionModel? _appVersionModel;
  AppVersionModel? get appVersionModel => _appVersionModel;

  final service = AppVersionService();

  Future<AppVersionModel?> getAppVersion() async{
    _isLoading = true;
    _appVersionModel = await service.getAppVersion();
    _isLoading = false;
    notifyListeners();
    return _appVersionModel;
  }

}