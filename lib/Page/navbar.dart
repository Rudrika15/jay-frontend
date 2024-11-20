import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flipcodeattendence/Page/call_log_page.dart';
import 'package:flipcodeattendence/Page/profile_page.dart';
import 'package:flipcodeattendence/featuers/Admin/page/admin_home_page.dart';
import 'package:flipcodeattendence/featuers/Admin/page/admin_leave_page.dart';
import 'package:flipcodeattendence/featuers/User/page/user_attendance_page.dart';
import 'package:flipcodeattendence/featuers/User/page/user_leave_page.dart';
import 'package:flipcodeattendence/helper/app_version_checker.dart';
import 'package:flipcodeattendence/helper/connectivity_service.dart';
import 'package:flipcodeattendence/helper/string_helper.dart';
import 'package:flipcodeattendence/mixins/navigator_mixin.dart';
import 'package:flipcodeattendence/theme/app_colors.dart';
import 'package:flutter/cupertino.dart';
import '/provider/login_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../widget/dialog_widget.dart';

class Navbar extends StatefulWidget {
  @override
  _NavbarState createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> with NavigatorMixin {
  int _selectedIndex = 0;
  final _connectivityService = ConnectivityService();

  @override
  void initState() {
    super.initState();
    // Provider.of<LoginProvider>(context, listen: false).updateToken();
    Provider.of<LoginProvider>(context, listen: false).getUserRole();
  }

  @override
  void dispose() {
    _connectivityService.dispose();
    super.dispose();
  }

  Future<void> _showExitAppDialog() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return DialogWidget(
          icon: CupertinoIcons.square_arrow_left,
          text: StringHelper.appExitWarning,
          onPressed: () => SystemNavigator.pop(),
          buttonText: StringHelper.yes,
          context: context,
        );
      },
    );
  }

  // Future<void> setupInteractedMessage() async {
  //   // Get any messages which caused the application to open from
  //   // a terminated state.
  //   RemoteMessage? initialMessage =
  //       await FirebaseMessaging.instance.getInitialMessage();
  //
  //   // If the message also contains a data property with a "type" of "chat",
  //   // navigate to a chat screen
  //   if (initialMessage != null) {
  //     _handleMessage(initialMessage);
  //   }
  //
  //   // Also handle any interaction when the app is in the background via a
  //   // Stream listener
  //   FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  // }

  // void _handleMessage(RemoteMessage message) {
  //   print('===============NOTIFICATION===============');
  //   print(message);
  //   print(message.data);
  //   print(message.category);
  //   Provider.of<LoginProvider>(context, listen: false)
  //       .getUserRole()
  //       .then((value) {
  //     print(value);
  //     push(
  //       context,
  //       NotificationScreen(isAdmin: value?.toLowerCase() == 'admin'),
  //     );
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<LoginProvider>(
        builder: (context, loginValue, child) {
          final userRole = loginValue.userRole?.trim().toLowerCase();
          return PopScope(
            canPop: false,
            onPopInvoked: (didPop) async {
              if (didPop) return;
              await _showExitAppDialog();
            },
            child: StreamBuilder<List<ConnectivityResult>>(
              stream: _connectivityService.connectivityStream,
              initialData: _connectivityService.connectivityResult,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }
                final result = snapshot.data!;
                final bool isDisconnected =
                    result.first == ConnectivityResult.none;
                return (isDisconnected)
                    ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(CupertinoIcons.wifi_exclamationmark,
                          color: AppColors.aPrimary, size: 100),
                      Text(
                        'No connection',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                )
                    : loginValue.isLoading
                    ? Center(
                  child: CircularProgressIndicator(),
                )
                    : [
                  userRole == 'admin'
                      ? AdminHomePage()
                      : UserAttendancePage(),
                  userRole == 'admin'
                      ? AdminLeavePage()
                      : UserLeavePage(),
                  CallLogPage(),
                  ProfilePage(),
                ][_selectedIndex];
              },
            ),
          );
        },
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (value) {
          setState(() {
            _selectedIndex = value;
          });
        },
        destinations: [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(
              icon: Icon(CupertinoIcons.arrow_up_right), label: 'Leave'),
          NavigationDestination(
              icon: Icon(Icons.list_alt_rounded), label: 'Call log'),
          NavigationDestination(
              icon: Icon(CupertinoIcons.person_fill),
              label: 'Profile',
              selectedIcon: Icon(CupertinoIcons.person)),
        ],
      ),
    );
  }
}
