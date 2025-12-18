import 'package:artisans_project_mobile/core/constants/app_dimensions.dart';
import 'package:artisans_project_mobile/features/exercises/domain/entities/exercise_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExerciseInfo extends StatelessWidget {
  final ExerciseEntity exercise;

  const ExerciseInfo({super.key, required this.exercise});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppDimensions.paddingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            exercise.name.toUpperCase(),
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w900,
              overflow: TextOverflow.ellipsis,
              color: Theme.of(context).colorScheme.onSurface,
              height: 1.1,
              letterSpacing: -0.5,
            ),
          ),
          SizedBox(height: AppDimensions.spaceMedium),
          Wrap(
            spacing: AppDimensions.spaceSmall,
            runSpacing: AppDimensions.spaceSmall,
            children: [
              _buildTag(context, 'Body Part', exercise.bodyPart),
              if (exercise.equipment.isNotEmpty)
                _buildTag(context, 'Equipment', exercise.equipment),
              if (exercise.target.isNotEmpty)
                _buildTag(context, 'Target', exercise.target),
              if (exercise.difficulty.isNotEmpty)
                _buildTag(context, 'Difficulty', exercise.difficulty),
              if (exercise.type.isNotEmpty)
                _buildTag(context, 'Type', exercise.type),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTag(BuildContext context, String label, String value) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingSmall,
        vertical: 8.h,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label.toUpperCase(),
            style: TextStyle(
              fontSize: 10.sp,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 10.sp,
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
