import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/exercise_entity.dart';

abstract class ExerciseRepository {
  Future<Either<Failure, List<ExerciseEntity>>> getExercises({
    int limit = 10,
    int offset = 0,
    String? searchQuery,
    String? bodyPart,
  });
}
