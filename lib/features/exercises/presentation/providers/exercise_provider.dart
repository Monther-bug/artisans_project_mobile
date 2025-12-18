import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import '../../domain/entities/exercise_entity.dart';
import '../../domain/repositories/exercise_repository.dart';
import '../../data/datasources/exercise_remote_data_source.dart';
import '../../data/datasources/exercise_local_data_source.dart';
import '../../data/repositories/exercise_repository_impl.dart';

final exerciseRemoteDataSourceProvider = Provider<ExerciseRemoteDataSource>((
  ref,
) {
  return ExerciseRemoteDataSourceImpl(ref.watch(dioProvider));
});

final exerciseLocalDataSourceProvider = Provider<ExerciseLocalDataSource>((
  ref,
) {
  return ExerciseLocalDataSourceImpl();
});

final exerciseRepositoryProvider = Provider<ExerciseRepository>((ref) {
  return ExerciseRepositoryImpl(
    ref.watch(exerciseRemoteDataSourceProvider),
    ref.watch(exerciseLocalDataSourceProvider),
  );
});

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

final searchExerciseListProvider =
    NotifierProvider<SearchExerciseListNotifier, ExerciseListState>(() {
      return SearchExerciseListNotifier();
    });

class ExerciseListNotifier extends Notifier<ExerciseListState> {
  int _offset = 0;
  static const _limit = 10;

  ExerciseRepository get _repository => ref.read(exerciseRepositoryProvider);

  @override
  ExerciseListState build() {
    Future.microtask(() => fetchExercises());
    return const ExerciseListState(isLoading: true);
  }

  Future<void> updateFilters({String? search, String? bodyPart}) async {
    _offset = 0;

    state = ExerciseListState(
      isLoading: true,
      searchQuery: search ?? state.searchQuery,
      selectedBodyPart: bodyPart ?? state.selectedBodyPart,
      exercises: [],
    );

    await fetchExercises();
  }

  Future<void> refresh() async {
    _offset = 0;
    state = state.copyWith(
      isLoading: true,
      exercises: [],
      hasReachedMax: false,
      errorMessage: null,
    );
    await fetchExercises();
  }

  Future<void> fetchExercises() async {
    if (state.hasReachedMax && !state.isLoading) return;

    if (state.isLoading && state.exercises.isNotEmpty && _offset > 0) {
      return;
    }

    if (state.exercises.isNotEmpty) {
      state = state.copyWith(isLoading: true, errorMessage: null);
    }

    final result = await _repository.getExercises(
      limit: _limit,
      offset: _offset,
      searchQuery: state.searchQuery,
      bodyPart: state.selectedBodyPart == 'All' ? null : state.selectedBodyPart,
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

class SearchExerciseListNotifier extends Notifier<ExerciseListState> {
  int _offset = 0;
  static const _limit = 10;

  ExerciseRepository get _repository => ref.read(exerciseRepositoryProvider);

  @override
  ExerciseListState build() {
    return const ExerciseListState();
  }

  Future<void> updateFilters({String? search, String? bodyPart}) async {
    _offset = 0;

    state = ExerciseListState(
      isLoading: true,
      searchQuery: search ?? state.searchQuery,
      selectedBodyPart: bodyPart ?? state.selectedBodyPart,
      exercises: [],
    );

    await fetchExercises();
  }

  Future<void> fetchExercises() async {
    if (state.hasReachedMax && !state.isLoading) return;

    if (state.isLoading && state.exercises.isNotEmpty && _offset > 0) {
      return;
    }

    if (state.exercises.isNotEmpty) {
      state = state.copyWith(isLoading: true, errorMessage: null);
    }

    final result = await _repository.getExercises(
      limit: _limit,
      offset: _offset,
      searchQuery: state.searchQuery,
      bodyPart: state.selectedBodyPart == 'All' ? null : state.selectedBodyPart,
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
