import 'package:intl/intl.dart';

class DateFormatHelper {
  static DateTime formatHourMinuteSecond({required String time}) {
    return DateFormat('HH:mm:ss').parse(time);
  }

  static int getTotalSeconds({required DateTime time}) {
    return (time.hour * 3600) + (time.minute * 60) + time.second;
  }
}