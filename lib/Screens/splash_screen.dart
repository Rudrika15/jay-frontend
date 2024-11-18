import '/helper/string_helper.dart';
import '/mixins/navigator_mixin.dart';
import '/service/shared_preferences_service.dart';
import 'package:flutter/material.dart';

import 'login_screen.dart';
import 'navbar_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with NavigatorMixin {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  void _navigateToNextScreen() async {
    final token = await SharedPreferencesService.getUserToken();

    Future.delayed(
      Duration(seconds: 2),
      () {
        (token == null || token == '' || token.isEmpty)
            ? pushReplacement(context, Login())
            : pushReplacement(context, Navbar());
      },
    ); // simulate loading time
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
