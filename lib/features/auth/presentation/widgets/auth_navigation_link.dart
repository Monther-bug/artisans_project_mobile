import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AuthNavigationLink extends StatelessWidget {
  final String text;
  final String actionText;
  final VoidCallback onTap;

  const AuthNavigationLink({
    super.key,
    required this.text,
    required this.actionText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(text),
        TextButton(
          onPressed: onTap,
          child: Text(
            actionText,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 16.sp,
            ),
          ),
        ),
      ],
    );
  }
}
