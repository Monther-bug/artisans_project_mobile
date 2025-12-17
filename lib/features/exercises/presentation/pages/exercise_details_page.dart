import 'package:artisans_project_mobile/core/constants/app_dimensions.dart';
import 'package:artisans_project_mobile/features/exercises/presentation/widgets/exercise_header.dart';
import 'package:artisans_project_mobile/features/exercises/presentation/widgets/exercise_info.dart';
import 'package:artisans_project_mobile/features/exercises/presentation/widgets/exercise_instructions.dart';
import 'package:artisans_project_mobile/features/exercises/presentation/widgets/exercise_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/exercise_entity.dart';
import 'package:artisans_project_mobile/features/favorites/presentation/providers/favorites_provider.dart';

class ExerciseDetailsPage extends ConsumerWidget {
  final ExerciseEntity exercise;

  const ExerciseDetailsPage({super.key, required this.exercise});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        actions: [
          Consumer(
            builder: (context, ref, child) {
              final isFav = ref.watch(
                favoritesProvider.select(
                  (s) => s.favoriteIds.contains(exercise.id),
                ),
              );
              return IconButton(
                icon: Icon(isFav ? Icons.favorite : Icons.favorite_border),
                color: isFav ? Colors.red : Colors.black,
                onPressed: () {
                  ref.read(favoritesProvider.notifier).toggleFavorite(exercise);
                },
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ExerciseHeader(gifUrl: exercise.gifUrl),
            SizedBox(height: AppDimensions.spaceLarge),
            ExerciseInfo(exercise: exercise),
            SizedBox(height: AppDimensions.spaceXLarge),
            ExerciseSafety(safetyInfo: exercise.safetyInfo),
            SizedBox(height: AppDimensions.spaceXLarge),
            ExerciseInstructions(instructions: exercise.instructions),
            SizedBox(height: AppDimensions.spaceXLarge),
          ],
        ),
      ),
    );
  }
}
