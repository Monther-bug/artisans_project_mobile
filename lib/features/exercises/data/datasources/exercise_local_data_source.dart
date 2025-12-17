import '../../../../core/constants/dummy_exercises.dart';
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
    await Future.delayed(const Duration(milliseconds: 500));

    var filtered = DummyExercises.data
        .map((e) => ExerciseModel.fromJson(e))
        .toList();

    if (searchQuery != null && searchQuery.isNotEmpty) {
      filtered = filtered
          .where(
            (e) => e.name.toLowerCase().contains(searchQuery.toLowerCase()),
          )
          .toList();
    }

    if (bodyPart != null && bodyPart.isNotEmpty && bodyPart != 'All') {
      filtered = filtered
          .where((e) => e.bodyPart.toLowerCase() == bodyPart.toLowerCase())
          .toList();
    }

    if (offset >= filtered.length) {
      return [];
    }

    final end = (offset + limit) < filtered.length
        ? (offset + limit)
        : filtered.length;
    return filtered.sublist(offset, end);
  }
}
