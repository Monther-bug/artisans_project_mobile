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
  // Search and Filter will be added in Phase 4, but good to anticipate
}
