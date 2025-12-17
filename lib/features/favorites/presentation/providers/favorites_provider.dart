import 'package:artisans_project_mobile/features/exercises/domain/entities/exercise_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repositories/favorites_repository.dart';
import '../../data/datasources/favorites_local_data_source.dart';
import '../../data/repositories/favorites_repository_impl.dart';

final favoritesLocalDataSourceProvider = Provider<FavoritesLocalDataSource>((
  ref,
) {
  return FavoritesLocalDataSourceImpl();
});

final favoritesRepositoryProvider = Provider<FavoritesRepository>((ref) {
  return FavoritesRepositoryImpl(ref.watch(favoritesLocalDataSourceProvider));
});

class FavoritesState {
  final List<ExerciseEntity> favorites;
  final Set<String> favoriteIds;
  final bool isLoading;

  const FavoritesState({
    this.favorites = const [],
    this.favoriteIds = const {},
    this.isLoading = false,
  });

  FavoritesState copyWith({
    List<ExerciseEntity>? favorites,
    Set<String>? favoriteIds,
    bool? isLoading,
  }) {
    return FavoritesState(
      favorites: favorites ?? this.favorites,
      favoriteIds: favoriteIds ?? this.favoriteIds,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

final favoritesProvider = NotifierProvider<FavoritesNotifier, FavoritesState>(
  () {
    return FavoritesNotifier();
  },
);

class FavoritesNotifier extends Notifier<FavoritesState> {
  FavoritesRepository get _repository => ref.read(favoritesRepositoryProvider);

  @override
  FavoritesState build() {
    Future.microtask(() => loadFavorites());
    return const FavoritesState(isLoading: true);
  }

  Future<void> loadFavorites() async {
    state = state.copyWith(isLoading: true);
    final result = await _repository.getFavorites();
    result.fold((failure) => state = state.copyWith(isLoading: false), (
      favorites,
    ) {
      state = state.copyWith(
        isLoading: false,
        favorites: favorites,
        favoriteIds: favorites.map((e) => e.id).toSet(),
      );
    });
  }

  Future<void> toggleFavorite(ExerciseEntity exercise) async {
    final isFav = state.favoriteIds.contains(exercise.id);
    if (isFav) {
      await _repository.removeFavorite(exercise.id);
    } else {
      await _repository.addFavorite(exercise);
    }
    await loadFavorites();
  }

  bool isFavorite(String id) => state.favoriteIds.contains(id);
}
