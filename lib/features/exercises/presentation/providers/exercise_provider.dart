import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/injection.dart';
import '../../domain/entities/exercise_entity.dart';
import '../../domain/usecases/get_exercises_usecase.dart';

class ExerciseListState extends Equatable {
  final List<ExerciseEntity> exercises;
  final bool isLoading;
  final String? errorMessage;
  final bool hasReachedMax;
  final String? searchQuery;
  final String? selectedBodyPart;

  const ExerciseListState({
    this.exercises = const [],
    this.isLoading = false,
    this.errorMessage,
    this.hasReachedMax = false,
    this.searchQuery,
    this.selectedBodyPart,
  });

  ExerciseListState copyWith({
    List<ExerciseEntity>? exercises,
    bool? isLoading,
    String? errorMessage,
    bool? hasReachedMax,
    String? searchQuery,
    String? selectedBodyPart,
  }) {
    return ExerciseListState(
      exercises: exercises ?? this.exercises,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedBodyPart: selectedBodyPart ?? this.selectedBodyPart,
    );
  }

  @override
  List<Object?> get props => [
    exercises,
    isLoading,
    errorMessage,
    hasReachedMax,
    searchQuery,
    selectedBodyPart,
  ];
}

final exerciseListProvider =
    NotifierProvider<ExerciseListNotifier, ExerciseListState>(() {
      return ExerciseListNotifier();
    });

class ExerciseListNotifier extends Notifier<ExerciseListState> {
  late final GetExercisesUseCase _getExercisesUseCase;
  int _offset = 0;
  static const _limit = 10;

  @override
  ExerciseListState build() {
    _getExercisesUseCase = getIt<GetExercisesUseCase>();
    Future.microtask(() => fetchExercises());
    return const ExerciseListState(isLoading: true);
  }

  Future<void> updateFilters({String? search, String? bodyPart}) async {
    _offset = 0;
    // If we pass null, we might mean "clear" or "keep". Let's assume passed values replace current.
    // If search is passed, use it. If bodyPart is passed, use it.
    // Simpler: require both or handle state copy.
    // Let's implement robust update.

    // We update state with new filters and clear list
    state = ExerciseListState(
      isLoading: true,
      searchQuery: search ?? state.searchQuery,
      selectedBodyPart: bodyPart ?? state.selectedBodyPart,
      exercises: [], // Clear list
    );

    await fetchExercises();
  }

  Future<void> fetchExercises() async {
    if (state.hasReachedMax && !state.isLoading) return;

    if (state.isLoading && state.exercises.isNotEmpty && _offset > 0) {
      // already loading more
      return;
    }

    // Only set loading if it's load more (if list not empty)
    // If list is empty (initial or reset), we already set loading in updateFilters or build.
    if (state.exercises.isNotEmpty) {
      state = state.copyWith(isLoading: true, errorMessage: null);
    }

    final result = await _getExercisesUseCase(
      GetExercisesParams(
        limit: _limit,
        offset: _offset,
        searchQuery: state.searchQuery,
        bodyPart: state.selectedBodyPart == 'All'
            ? null
            : state.selectedBodyPart,
      ),
    );

    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        errorMessage: failure.message,
      ),
      (newExercises) {
        if (newExercises.isEmpty) {
          state = state.copyWith(isLoading: false, hasReachedMax: true);
        } else {
          _offset += _limit;
          state = state.copyWith(
            isLoading: false,
            exercises: [...state.exercises, ...newExercises],
            hasReachedMax: newExercises.length < _limit,
          );
        }
      },
    );
  }
}
