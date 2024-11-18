import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class ActionWidget extends StatelessWidget {
  final IconData icon;
  final void Function()? onTap;
  const ActionWidget({super.key, required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.grey),
                shape: BoxShape.circle),
            child: Icon(icon, size: 20)),
        onTap: onTap);
  }
}

