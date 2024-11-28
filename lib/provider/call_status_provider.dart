import 'package:flutter/cupertino.dart';

import '../helper/enum_helper.dart';

class CallStatusProvider extends ChangeNotifier {
  CallStatusEnum _callStatusEnum = CallStatusEnum.allocated;
  CallStatusEnum get callStatusEnum => _callStatusEnum;

  void changeStatus(CallStatusEnum status) {
    _callStatusEnum = status;
    notifyListeners();
  }
}