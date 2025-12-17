import 'package:artisans_project_mobile/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/exercise_provider.dart';
import '../../../../shared/widgets/exercise_card.dart';

class ExerciseListView extends ConsumerWidget {
  const ExerciseListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(exerciseListProvider);

    if (state.isLoading && state.exercises.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state.errorMessage != null && state.exercises.isEmpty) {
      return Center(child: Text(state.errorMessage!));
    }
    if (state.exercises.isEmpty) {
      return Center(
        child: Text(AppLocalizations.of(context)!.noExercisesFound),
      );
    }

    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (!state.hasReachedMax &&
            !state.isLoading &&
            scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
          ref.read(exerciseListProvider.notifier).fetchExercises();
        }
        return false;
      },
      child: ListView.builder(
        itemCount: state.exercises.length + (state.isLoading ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= state.exercises.length) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator(),
              ),
            );
          }
          final exercise = state.exercises[index];
          return ExerciseCard(
            exercise: exercise,
            onTap: () {
              context.go('/exercise/${exercise.id}', extra: exercise);
            },
          );
        },
      ),
    );
  }
}
