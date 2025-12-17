import 'package:artisans_project_mobile/l10n/app_localizations.dart';
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
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.favorites)),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : state.favorites.isEmpty
          ? Center(child: Text(AppLocalizations.of(context)!.noFavoritesYet))
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
