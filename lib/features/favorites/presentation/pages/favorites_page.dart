import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/widgets/exercise_card.dart';
import '../providers/favorites_provider.dart';

class FavoritesPage extends ConsumerWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(favoritesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : state.favorites.isEmpty
          ? const Center(child: Text('No favorites yet'))
          : ListView.builder(
              itemCount: state.favorites.length,
              itemBuilder: (context, index) {
                final exercise = state.favorites[index];
                return ExerciseCard(
                  exercise: exercise,
                  onTap: () {
                    context.push('/exercise/${exercise.id}', extra: exercise);
                  },
                );
              },
            ),
    );
  }
}
