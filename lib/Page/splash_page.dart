import 'package:flipcodeattendence/Page/login_page.dart';
import 'package:flipcodeattendence/featuers/Admin/page/admin_nav_bar.dart';
import 'package:flipcodeattendence/featuers/Client/page/client_nav_bar.dart';
import 'package:flipcodeattendence/featuers/User/page/user_nav_bar.dart';
import 'package:flipcodeattendence/provider/login_provider.dart';
import 'package:flipcodeattendence/theme/app_colors.dart';
import 'package:provider/provider.dart';

import '/helper/string_helper.dart';
import '/mixins/navigator_mixin.dart';
import '/service/shared_preferences_service.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with NavigatorMixin {
  @override
  void initState() {
    super.initState();
    Provider.of<LoginProvider>(context, listen: false).setUserRole();
    _navigateToNextScreen();
  }

  void _navigateToNextScreen() async {
    final token = await SharedPreferencesService.getUserToken();
    Future.delayed(
      Duration(seconds: 2),
      () {
        if (token == null || token.isEmpty) {
          pushReplacement(context, LoginPage());
        } else {
          Provider.of<LoginProvider>(context, listen: false)
              .getUserRole()
              .then((value) {
            final isAdmin = context.read<LoginProvider>().isAdmin;
            final isUser = context.read<LoginProvider>().isUser;
            (isAdmin)
                ? pushReplacement(context, AdminNavbar())
                : (isUser)
                    ? pushReplacement(context, UserNavbar())
                    : pushReplacement(context, ClientNavbar());
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appLogoColor,
        body: Center(
          child: Image.asset(
            'assets/jay_infotech_app_icon_splash.png',
            width: 250,
          ),
        ));
  }
}
