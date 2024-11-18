import '/models/today.dart';
import '/service/today_service.dart';
import 'package:flutter/cupertino.dart';

class TodayProvider extends ChangeNotifier {
  TodayService todayService = TodayService();
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  TodayModel? _todayData;
  TodayModel? get todayData => _todayData;

  Future<TodayModel?> getTodayService() async {
    _isLoading = true;
    // notifyListeners();
    _todayData = await todayService.getuserToday();
    _isLoading = false;
    notifyListeners();
    return _todayData;
  }
}
