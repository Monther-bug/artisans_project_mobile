import 'package:artisans_project_mobile/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
              Expanded(child: _buildList(context, state, ref)),
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
          Text(
            AppLocalizations.of(context)!.discoverExercises,
            style: TextStyle(
              fontSize: 28.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 16.h),
          TextField(
            style: TextStyle(color: Colors.black, fontSize: 16.sp),
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context)!.searchExercises,
              hintStyle: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 14.sp,
              ),
              prefixIcon: Icon(Icons.search, color: Colors.black, size: 24.r),
              filled: true,
              fillColor: Colors.grey.shade100,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.r),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 16.h,
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
      height: 40.h,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        scrollDirection: Axis.horizontal,
        itemCount: bodyParts.length,
        separatorBuilder: (_, __) => SizedBox(width: 8.w),
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
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: isSelected ? Colors.black : Colors.white,
                borderRadius: BorderRadius.circular(24.r),
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
                  fontSize: 12.sp,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildList(
    BuildContext context,
    ExerciseListState state,
    WidgetRef ref,
  ) {
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
