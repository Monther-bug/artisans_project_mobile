import 'package:artisans_project_mobile/core/errors/failures.dart';
import 'package:artisans_project_mobile/features/exercises/domain/entities/exercise_entity.dart';
import 'package:dartz/dartz.dart';

abstract class FavoritesRepository {
  Future<Either<Failure, List<ExerciseEntity>>> getFavorites();
  Future<Either<Failure, void>> addFavorite(ExerciseEntity exercise);
  Future<Either<Failure, void>> removeFavorite(String exerciseId);
  Future<bool> isFavorite(String exerciseId);
}
