// This file contains methods that count total elapsed time of user since check in
import 'package:flipcodeattendence/helper/date_format_helper.dart';
import 'package:intl/intl.dart';

class TimeHelper {
  // Pass HH:mm:ss string
  static int getTotalSeconds({required String time}) {
    final parsedTime = DateFormatHelper.formatHourMinuteSecond(time: time);
    final totalSeconds = DateFormatHelper.getTotalSeconds(time: parsedTime);
    return totalSeconds;
  }

  static String getElapsedTime(
      {required String checkInTime,
      String? onBreakTime,
      String? offBreakTime,
      String? checkOutTime}) {
    final now = DateFormat('HH:mm:ss').format(DateTime.now());
    final totalSecondsInNow = getTotalSeconds(time: now);
    final checkInSeconds = getTotalSeconds(time: checkInTime);

    if (onBreakTime == null && offBreakTime == null && checkOutTime == null) {
      final difference = totalSecondsInNow - checkInSeconds;
      return (difference == -1)
          ? formatTime(totalSeconds: 1)
          : formatTime(totalSeconds: difference);
    } else if (onBreakTime != null &&
        offBreakTime == null &&
        checkOutTime == null) {
      final onBreakSeconds = getTotalSeconds(time: onBreakTime);
      final difference = onBreakSeconds - checkInSeconds;
      return formatTime(totalSeconds: difference);
    } else if (onBreakTime != null &&
        offBreakTime != null &&
        checkOutTime == null) {
      final totalBreakSeconds = countBreakSeconds(
          onBreakTime: onBreakTime, offBreakTime: offBreakTime);
      final difference = totalSecondsInNow - checkInSeconds - totalBreakSeconds;
      return formatTime(totalSeconds: difference);
    } else {
      final checkOutSeconds = getTotalSeconds(time: checkOutTime!);
      final totalBreakSeconds = countBreakSeconds(
          onBreakTime: onBreakTime!, offBreakTime: offBreakTime!);
      final difference = checkOutSeconds - checkInSeconds - totalBreakSeconds;
      return formatTime(totalSeconds: difference);
    }
  }

  static int countBreakSeconds(
      {required String onBreakTime, required String offBreakTime}) {
    final onBreakSeconds = getTotalSeconds(time: onBreakTime);
    final offBreakSeconds = getTotalSeconds(time: offBreakTime);

    final totalBreakSeconds = offBreakSeconds - onBreakSeconds;
    return totalBreakSeconds;
  }

  static int countWorkSeconds(
      {required String checkInTime,
      required String checkOutTime,
      required String onBreakTime,
      required String offBreakTime}) {
    final checkInSeconds = getTotalSeconds(time: checkInTime);
    final checkOutSeconds = getTotalSeconds(time: checkOutTime);
    final totalBreakSeconds =
        countBreakSeconds(onBreakTime: onBreakTime, offBreakTime: offBreakTime);
    final countWorkSeconds =
        checkOutSeconds - checkInSeconds - totalBreakSeconds;
    return countWorkSeconds;
  }

  static String formatTime(
      {required int totalSeconds, bool hourMinuteFormat = false}) {
    final hours = totalSeconds ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;
    final seconds = totalSeconds % 60;
    if (hourMinuteFormat) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
    } else {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
  }
}
