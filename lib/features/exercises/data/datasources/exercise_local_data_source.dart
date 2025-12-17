import '../models/exercise_model.dart';

abstract class ExerciseLocalDataSource {
  Future<List<ExerciseModel>> getExercises({
    int limit,
    int offset,
    String? searchQuery,
    String? bodyPart,
  });
}

class ExerciseLocalDataSourceImpl implements ExerciseLocalDataSource {
  @override
  Future<List<ExerciseModel>> getExercises({
    int limit = 10,
    int offset = 0,
    String? searchQuery,
    String? bodyPart,
  }) async {
    return [];
  }
}
