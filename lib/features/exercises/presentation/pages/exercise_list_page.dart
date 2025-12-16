import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/exercise_provider.dart';
import '../../../../shared/widgets/exercise_card.dart';

class ExerciseListPage extends ConsumerWidget {
  const ExerciseListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(exerciseListProvider);

    return Scaffold(
      backgroundColor: Colors.white,

      body: Builder(
        builder: (context) {
          return Column(
            children: [
              _buildSearchBar(context, ref, state),
              _buildFilterChips(context, ref, state),
              Expanded(child: _buildList(state, ref)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSearchBar(
    BuildContext context,
    WidgetRef ref,
    ExerciseListState state,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Discover Exercises',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            style: const TextStyle(color: Colors.black),
            decoration: InputDecoration(
              hintText: 'Search exercises...',
              hintStyle: TextStyle(color: Colors.grey.shade500),
              prefixIcon: const Icon(Icons.search, color: Colors.black),
              filled: true,
              fillColor: Colors.grey.shade100,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
            onSubmitted: (value) {
              ref
                  .read(exerciseListProvider.notifier)
                  .updateFilters(search: value);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips(
    BuildContext context,
    WidgetRef ref,
    ExerciseListState state,
  ) {
    final bodyParts = [
      'All',
      'back',
      'cardio',
      'chest',
      'lower arms',
      'lower legs',
      'neck',
      'shoulders',
      'upper arms',
      'upper legs',
      'waist',
    ];
    return SizedBox(
      height: 40,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: bodyParts.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final part = bodyParts[index];
          final isSelected = (state.selectedBodyPart ?? 'All') == part;
          return GestureDetector(
            onTap: () {
              ref
                  .read(exerciseListProvider.notifier)
                  .updateFilters(bodyPart: part);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? Colors.black : Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: isSelected ? Colors.black : Colors.grey.shade300,
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                part.toUpperCase(),
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildList(ExerciseListState state, WidgetRef ref) {
    if (state.isLoading && state.exercises.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state.errorMessage != null && state.exercises.isEmpty) {
      return Center(child: Text(state.errorMessage!));
    }
    if (state.exercises.isEmpty) {
      return const Center(child: Text('No exercises found.'));
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
