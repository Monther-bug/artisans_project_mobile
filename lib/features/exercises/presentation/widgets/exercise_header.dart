import 'package:artisans_project_mobile/core/constants/app_dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExerciseHeader extends StatelessWidget {
  final String gifUrl;

  const ExerciseHeader({super.key, required this.gifUrl});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppDimensions.paddingMedium),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        child: Image.network(
          gifUrl,
          height: 300.h,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              height: 300.h,
              width: double.infinity,
              color: Colors.grey.shade100,
              child: Icon(
                Icons.fitness_center,
                size: 60.sp,
                color: Colors.grey,
              ),
            );
          },
        ),
      ),
    );
  }
}
