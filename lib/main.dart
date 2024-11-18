import 'package:firebase_core/firebase_core.dart';
import 'package:flipcodeattendence/provider/app_provider.dart';
import 'package:flipcodeattendence/provider/notification_provider.dart';
import 'package:flipcodeattendence/provider/report_provider.dart';
import 'package:flipcodeattendence/provider/task_provider.dart';
import '/provider/attendance_provider.dart';
import '/provider/leave_provider.dart';
import '/provider/login_provider.dart';
import '/provider/show_attendance_provider.dart';
import '/provider/today_provider.dart';
import '/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:provider/provider.dart';
import 'Screens/splash_screen.dart';
import 'helper/notification_helper.dart';

void main() async {
  // HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseMessagingUtils.initNotifications();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => LoginProvider(),
        ),
        ChangeNotifierProvider(create: (context) => AttendanceProvider()),
        ChangeNotifierProvider(create: (context) => TodayProvider()),
        ChangeNotifierProvider(create: (context) => ShowAttendanceProvider()),
        ChangeNotifierProvider(create: (context) => LeaveProvider()),
        ChangeNotifierProvider(create: (context) => NotificationProvider()),
        ChangeNotifierProvider(create: (context) => TaskProvider()),
        ChangeNotifierProvider(create: (context) => AppProvider()),
        ChangeNotifierProvider(create: (context) => ReportProvider()),

      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flipcode Attendance',
        theme: AppTheme.appThemeData(),
        home: SplashScreen(),
      ),
    );
  }
}

// class MyHttpOverrides extends HttpOverrides {
//   @override
//   HttpClient createHttpClient(SecurityContext? context) {
//     return super.createHttpClient(context)
//       ..badCertificateCallback =
//           (X509Certificate cert, String host, int port) => true;
//   }
// }
