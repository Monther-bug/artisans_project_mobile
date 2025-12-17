import 'package:artisans_project_mobile/core/constants/app_dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExerciseSafety extends StatelessWidget {
  final String safetyInfo;

  const ExerciseSafety({super.key, required this.safetyInfo});

  @override
  Widget build(BuildContext context) {
    if (safetyInfo.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppDimensions.paddingMedium),
      padding: EdgeInsets.all(AppDimensions.paddingMedium),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        border: Border.all(color: Colors.orange.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: Colors.orange.shade800,
                size: 20.sp,
              ),
              SizedBox(width: AppDimensions.spaceSmall),
              Text(
                'Safety First',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.orange.shade900,
                  fontSize: 14.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: AppDimensions.spaceSmall),
          Text(
            safetyInfo,
            style: TextStyle(
              color: Colors.orange.shade900,
              height: 1.5,
              fontSize: 14.sp,
            ),
          ),
        ],
      ),
    );
  }
}
