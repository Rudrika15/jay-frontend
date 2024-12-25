import 'package:flipcodeattendence/featuers/User/staff_provider.dart';
import 'package:flipcodeattendence/provider/app_provider.dart';
import 'package:flipcodeattendence/provider/call_log_provider.dart';
import 'package:flipcodeattendence/provider/call_status_provider.dart';
import 'package:flipcodeattendence/provider/client_provider.dart';
import 'package:flipcodeattendence/provider/notification_provider.dart';
import 'package:flipcodeattendence/provider/report_provider.dart';
import 'package:flipcodeattendence/provider/task_provider.dart';
import 'package:flipcodeattendence/provider/team_provider.dart';
import '/provider/attendance_provider.dart';
import '/provider/leave_provider.dart';
import '/provider/login_provider.dart';
import '/provider/show_attendance_provider.dart';
import '/provider/today_provider.dart';
import '/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:provider/provider.dart';

import 'Page/splash_page.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LoginProvider()),
        ChangeNotifierProvider(create: (context) => AttendanceProvider()),
        ChangeNotifierProvider(create: (context) => TodayProvider()),
        ChangeNotifierProvider(create: (context) => ShowAttendanceProvider()),
        ChangeNotifierProvider(create: (context) => LeaveProvider()),
        ChangeNotifierProvider(create: (context) => NotificationProvider()),
        ChangeNotifierProvider(create: (context) => TaskProvider()),
        ChangeNotifierProvider(create: (context) => AppProvider()),
        ChangeNotifierProvider(create: (context) => ReportProvider()),
        ChangeNotifierProvider(create: (context) => ClientProvider()),
        ChangeNotifierProvider(create: (context) => CallLogProvider()),
        ChangeNotifierProvider(create: (context) => TeamProvider()),
        ChangeNotifierProvider(create: (context) => CallStatusProvider()),
        ChangeNotifierProvider(create: (context) => StaffProvider()),
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Jay Infotech',
        theme: AppTheme.appThemeData(),
        home: SplashPage(),
      ),
    );
  }
}
