import 'package:flutter/material.dart';

mixin NavigatorMixin {
  push(BuildContext context, Widget screen) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => screen,
    ));
  }

  pushReplacement(BuildContext context, Widget screen) {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => screen));
  }

  pop(BuildContext context) {
    Navigator.of(context).pop();
  }
}
