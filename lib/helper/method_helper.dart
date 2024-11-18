import 'package:flipcodeattendence/helper/string_helper.dart';
import 'package:flipcodeattendence/theme/app_colors.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class MethodHelper {
  static formateUtcDate({String? value, String? formate}) {
    if (value != null) {
      DateTime dateTime = DateTime.parse(value);
      String formattedDate = DateFormat(formate ?? 'dd/MM/yyyy hh:mm a')
          .format(dateTime.toLocal());
      return formattedDate;
    } else {
      return '';
    }
  }
  static SnackbarController showSnackBar({
    bool isSuccess = true,
    SnackPosition snackPosition = SnackPosition.TOP,
    required String message}) {
    return Get.showSnackbar(
      GetSnackBar(
        title: isSuccess ? StringHelper.success : StringHelper.failed,
        message: message,
        duration: Duration(seconds: 2),
        backgroundColor: isSuccess ? AppColors.green : AppColors.red,
        snackPosition: snackPosition,
      ),
    );
  }

  static String customDateFormateForDateRange(String? stringDate) {
    if (stringDate != null) {
      DateTime parseDate = DateFormat("yyyy-MM-dd").parse(stringDate);
      var inputDate = DateTime.parse(parseDate.toString());
      var outputFormat = DateFormat('dd MMM yy');
      var outputDate = outputFormat.format(inputDate);
      return outputDate.toString();
    } else {
      return '';
    }
  }

  static String yyyyMMddDateFormat(String? stringDate) {
    if (stringDate != null) {
      DateTime parseDate = DateFormat("yyyy-MM-dd").parse(stringDate);
      var inputDate = DateTime.parse(parseDate.toString());
      var outputFormat = DateFormat('yyyy-MM-dd');
      var outputDate = outputFormat.format(inputDate);
      return outputDate.toString();
    } else {
      return '';
    }
  }

  static bool isCurrentDate(String? stringDate) {
    final currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    if (stringDate != null) {
      DateTime parseDate = DateFormat("yyyy-MM-dd").parse(stringDate);
      var inputDate = DateTime.parse(parseDate.toString());
      var outputFormat = DateFormat('yyyy-MM-dd');
      var outputDate = outputFormat.format(inputDate).toString();
      if(outputDate.trim() == currentDate.trim()) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }
}
