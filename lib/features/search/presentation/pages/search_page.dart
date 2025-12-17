import 'package:artisans_project_mobile/core/constants/app_dimensions.dart';
import 'package:artisans_project_mobile/features/search/presentation/widgets/search_empty_view.dart';
import 'package:artisans_project_mobile/features/search/presentation/widgets/search_input.dart';
import 'package:artisans_project_mobile/features/exercises/presentation/providers/exercise_provider.dart';
import 'package:artisans_project_mobile/shared/widgets/exercise_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(exerciseListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Search')),
      body: Padding(
        padding: EdgeInsets.all(AppDimensions.paddingMedium),
        child: Column(
          children: [
            SearchInput(
              hintText: 'What are you looking for?',
              controller: _searchController,
              onChanged: (value) {},
              onSubmitted: (value) {
                ref
                    .read(exerciseListProvider.notifier)
                    .updateFilters(search: value);
              },
            ),
            SizedBox(height: AppDimensions.spaceMedium),
            Expanded(child: _buildBody(state)),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(ExerciseListState state) {
    if (state.isLoading && state.exercises.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.exercises.isEmpty) {
      if (state.searchQuery != null && state.searchQuery!.isNotEmpty) {
        return Center(
          child: Text('No results found for "${state.searchQuery}"'),
        );
      }
      return const SearchEmptyView();
    }

    return ListView.builder(
      itemCount: state.exercises.length,
      itemBuilder: (context, index) {
        final exercise = state.exercises[index];
        return ExerciseCard(
          exercise: exercise,
          onTap: () {
            context.go('/exercise/${exercise.id}', extra: exercise);
          },
        );
      },
    );
  }
}
