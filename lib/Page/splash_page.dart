import 'package:flipcodeattendence/Page/login_page.dart';

import '/helper/string_helper.dart';
import '/mixins/navigator_mixin.dart';
import '/service/shared_preferences_service.dart';
import 'package:flutter/material.dart';

import 'navbar.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with NavigatorMixin {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  void _navigateToNextScreen() async {
    final token = await SharedPreferencesService.getUserToken();
    print(token);

    Future.delayed(
      Duration(seconds: 2),
      () {
        (token == null || token == '' || token.isEmpty)
            ? pushReplacement(context, LoginPage())
            : pushReplacement(context, Navbar());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Image.asset(
        StringHelper.appLogo,
        width: 250,
      ),
    ));
  }
}
