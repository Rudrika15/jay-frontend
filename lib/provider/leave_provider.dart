import 'package:flipcodeattendence/models/leave_requests_model.dart';
import 'package:flipcodeattendence/theme/app_colors.dart';
import 'package:get/get.dart';

import '/service/leave_service.dart';
import 'package:flutter/cupertino.dart';

import '../models/leavelist_model.dart';

class LeaveProvider extends ChangeNotifier {
  final leaveService = LeaveService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<bool> applyLeave(BuildContext context, dynamic body) async {
    _isLoading = true;
    notifyListeners();

    final value = await leaveService.applyLeave(context, body);

    _isLoading = false;
    notifyListeners();

    return value;
  }

  LeaveListModel? _leaveList;
  LeaveListModel? get leaveList => _leaveList;

  Future<void> getLeaveList() async {
    _isLoading = true;

    _leaveList = await leaveService.leaveRecord();

    _isLoading = false;
    notifyListeners();
  }

  LeaveRequestsModel? _leaveRequestsModel;
  LeaveRequestsModel? get leaveRequestsModel => _leaveRequestsModel;

  Future<LeaveRequestsModel?> getLeaveRequestList(
      {String? page, bool getCurrentDateLeave = false}) async {
    _isLoading = true;
    _leaveRequestsModel = await leaveService.getLeaveRequestList(page:page, getCurrentDateLeave : getCurrentDateLeave);
    _isLoading = false;
    notifyListeners();
    return _leaveRequestsModel;
  }

  bool _isUpdating = false;
  bool get isUpdating => _isUpdating;
  int? _updateId;
  int? get updateId => _updateId;
  Future<bool> leaveAction({
    required BuildContext context,
    required bool isApprove,
    int? leaveId,
    String? leaveActionText,
  }) async {
    _isUpdating = true;
    _updateId = leaveId;
    notifyListeners();

    final value = await leaveService.leaveAction(
        context, isApprove, leaveId.toString(), leaveActionText);
    if (value) {
      if (isApprove) {
        Get.showSnackbar(
          GetSnackBar(
            title: "Leave Approved",
            message: 'Leave approved successfully',
            duration: Duration(seconds: 2),
            backgroundColor: AppColors.green,
            snackPosition: SnackPosition.BOTTOM,
          ),
        );
      } else {
        Get.showSnackbar(
          GetSnackBar(
            title: "Leave Rejected",
            message: 'Leave Rejected successfully',
            duration: Duration(seconds: 2),
            backgroundColor: AppColors.green,
            snackPosition: SnackPosition.BOTTOM,
          ),
        );
      }
    }

    _isUpdating = false;
    notifyListeners();
    return value;
  }

  Future<bool> cancelLeave({
    required BuildContext context,
    required int? leaveId,
  }) async {
    _isUpdating = true;
    _updateId = leaveId;
    notifyListeners();

    final value = await leaveService.cancelLeave(context, leaveId.toString());
    if (value) {
      Get.showSnackbar(
        GetSnackBar(
          title: "Leave Cancelled",
          message: 'Leave Cancelled successfully',
          duration: Duration(seconds: 2),
          backgroundColor: AppColors.green,
          snackPosition: SnackPosition.BOTTOM,
        ),
      );
    }

    _isUpdating = false;
    notifyListeners();
    return value;
  }
}
