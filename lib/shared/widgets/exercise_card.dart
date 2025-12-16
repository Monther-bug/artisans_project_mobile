import 'package:flutter/material.dart';
import 'package:artisans_project_mobile/core/constants/app_dimensions.dart';
import '../../features/exercises/domain/entities/exercise_entity.dart';

class ExerciseCard extends StatelessWidget {
  final ExerciseEntity exercise;
  final VoidCallback? onTap;

  const ExerciseCard({super.key, required this.exercise, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingMedium, // Replaced 16
        vertical: AppDimensions.paddingSmall, // Replaced 8
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
      ),

      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          child: Padding(
            padding: EdgeInsets.all(AppDimensions.paddingMedium),
            child: Row(
              children: [
                Hero(
                  tag: 'exercise_${exercise.id}',
                  child: Container(
                    width: AppDimensions.logoSizeSmall,
                    height: AppDimensions.logoSizeSmall,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusSmall,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusSmall,
                      ),
                      child: Image.network(
                        exercise.gifUrl,
                        width: AppDimensions.logoSizeSmall,
                        height: AppDimensions.logoSizeSmall,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Icon(Icons.fitness_center, color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: AppDimensions.spaceMedium),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        exercise.name.toUpperCase(),

                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: AppDimensions.spaceSmall),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppDimensions.paddingSmall,
                          vertical: AppDimensions.paddingExtraSmall,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(
                            AppDimensions.radiusSmall,
                          ),
                        ),
                        child: Text(
                          '${exercise.bodyPart} | ${exercise.target}',
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: AppDimensions.iconSizeSmall,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
