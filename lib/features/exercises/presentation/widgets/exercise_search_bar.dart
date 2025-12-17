import 'package:artisans_project_mobile/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../providers/exercise_provider.dart';

class ExerciseSearchBar extends ConsumerWidget {
  const ExerciseSearchBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.discoverExercises,
            style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 26.h),
          TextField(
            style: TextStyle(fontSize: 16.sp),
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context)!.searchExercises,
              hintStyle: TextStyle(fontSize: 14.sp),
              prefixIcon: Icon(Icons.search, size: 24.r),
              filled: true,
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
}
