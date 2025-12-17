import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashTitle extends StatelessWidget {
  const SplashTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'ARTISANS',
      style: TextStyle(
        color: Colors.white,
        fontSize: 28.sp,
        fontWeight: FontWeight.bold,
        letterSpacing: 8,
      ),
    );
  }
}
