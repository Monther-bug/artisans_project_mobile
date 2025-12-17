import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/exercise_filter_chips.dart';
import '../widgets/exercise_list_view.dart';
import '../widgets/exercise_search_bar.dart';

class ExerciseListPage extends ConsumerWidget {
  const ExerciseListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Scaffold(
        body: Builder(
          builder: (context) {
            return const Column(
              children: [
                ExerciseSearchBar(),
                ExerciseFilterChips(),
                Expanded(child: ExerciseListView()),
              ],
            );
          },
        ),
      ),
    );
  }
}
