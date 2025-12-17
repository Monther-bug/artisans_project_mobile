import 'package:dartz/dartz.dart';

import 'package:artisans_project_mobile/core/errors/exceptions.dart';
import 'package:artisans_project_mobile/core/errors/failures.dart';
import 'package:artisans_project_mobile/features/exercises/data/models/exercise_model.dart';
import 'package:artisans_project_mobile/features/exercises/domain/entities/exercise_entity.dart';
import '../../domain/repositories/favorites_repository.dart';
import '../datasources/favorites_local_data_source.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  final FavoritesLocalDataSource _localDataSource;

  FavoritesRepositoryImpl(this._localDataSource);

  @override
  Future<Either<Failure, void>> addFavorite(ExerciseEntity exercise) async {
    try {
      final model = ExerciseModel(
        id: exercise.id,
        name: exercise.name,
        bodyPart: exercise.bodyPart,
        equipment: exercise.equipment,
        target: exercise.target,
        gifUrl: exercise.gifUrl,
        instructions: exercise.instructions,
        difficulty: exercise.difficulty,
        type: exercise.type,
        safetyInfo: exercise.safetyInfo,
        secondaryMuscles: exercise.secondaryMuscles,
      );
      await _localDataSource.addFavorite(model);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ExerciseEntity>>> getFavorites() async {
    try {
      final favorites = await _localDataSource.getFavorites();
      return Right(favorites);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<bool> isFavorite(String exerciseId) {
    return _localDataSource.isFavorite(exerciseId);
  }

  @override
  Future<Either<Failure, void>> removeFavorite(String exerciseId) async {
    try {
      await _localDataSource.removeFavorite(exerciseId);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
