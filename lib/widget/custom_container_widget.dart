import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class CustomContainer extends StatelessWidget {
  final IconData icon;
  final String time, label;

  const CustomContainer({Key? key, required this.icon, required this.time, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColors.onPrimaryLight,
        boxShadow: [
          BoxShadow(
            color: AppColors.grey.withOpacity(0.4),
            spreadRadius: 2,
            blurRadius: 2,
            offset: Offset(3, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(label),
                Icon(icon),
              ],
            ),
            SizedBox(height: 8),
            Text(time),
          ],
        ),
      ),
    );
  }
}