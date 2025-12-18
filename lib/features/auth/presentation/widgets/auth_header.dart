import 'package:artisans_project_mobile/core/constants/app_dimensions.dart';
import 'package:artisans_project_mobile/core/constants/app_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AuthHeader extends StatelessWidget {
  final String title;
  final String? subtitle;

  const AuthHeader({super.key, required this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Container(
            padding: EdgeInsets.all(AppDimensions.paddingSmall / 2),
            child: ClipOval(
              child: Image.asset(
                AppImages.logo,
                height: AppDimensions.logoSizeLarge,
                width: AppDimensions.logoSizeLarge,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        SizedBox(height: AppDimensions.spaceXLarge),
        Text(
          title,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
            fontSize: 28.sp,
          ),
        ),
        if (subtitle != null) ...[
          SizedBox(height: AppDimensions.spaceSmall),
          Text(
            subtitle!,
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: Colors.grey),
          ),
        ],
      ],
    );
  }
}
