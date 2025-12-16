import 'package:artisans_project_mobile/features/exercises/domain/entities/exercise_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/usecases/favorites_usecases.dart';

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
  late final GetFavoritesUseCase _getFavorites;
  late final AddFavoriteUseCase _addFavorite;
  late final RemoveFavoriteUseCase _removeFavorite;

  @override
  FavoritesState build() {
    _getFavorites = getIt<GetFavoritesUseCase>();
    _addFavorite = getIt<AddFavoriteUseCase>();
    _removeFavorite = getIt<RemoveFavoriteUseCase>();
    loadFavorites();
    return const FavoritesState(isLoading: true);
  }

  Future<void> loadFavorites() async {
    state = state.copyWith(isLoading: true);
    final result = await _getFavorites(const NoParams());
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
      await _removeFavorite(exercise.id);
    } else {
      await _addFavorite(exercise);
    }
    // Reload to stay simple, or optimistic update
    await loadFavorites();
  }

  bool isFavorite(String id) => state.favoriteIds.contains(id);
}
