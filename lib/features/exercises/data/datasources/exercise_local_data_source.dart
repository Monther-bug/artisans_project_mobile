import 'package:hive_flutter/hive_flutter.dart';
import '../models/exercise_model.dart';

abstract class ExerciseLocalDataSource {
  Future<List<ExerciseModel>> getExercises();
  Future<void> cacheExercises(List<ExerciseModel> exercises);
  Future<void> clearCache();
}

class ExerciseLocalDataSourceImpl implements ExerciseLocalDataSource {
  static const String boxName = 'exercises_box';

  @override
  Future<List<ExerciseModel>> getExercises() async {
    final box = await Hive.openBox<ExerciseModel>(boxName);
    return box.values.toList();
  }

  @override
  Future<void> cacheExercises(List<ExerciseModel> exercises) async {
    final box = await Hive.openBox<ExerciseModel>(boxName);
    final Map<String, ExerciseModel> exercisesMap = {
      for (var exercise in exercises) exercise.id: exercise,
    };
    await box.putAll(exercisesMap);
  }

  @override
  Future<void> clearCache() async {
    final box = await Hive.openBox<ExerciseModel>(boxName);
    await box.clear();
  }
}
