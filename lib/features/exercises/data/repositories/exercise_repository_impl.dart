import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/exercise_entity.dart';
import '../../domain/repositories/exercise_repository.dart';
import '../datasources/exercise_local_data_source.dart';
import '../datasources/exercise_remote_data_source.dart';

class ExerciseRepositoryImpl implements ExerciseRepository {
  final ExerciseRemoteDataSource _remoteDataSource;
  final ExerciseLocalDataSource _localDataSource;

  ExerciseRepositoryImpl(this._remoteDataSource, this._localDataSource);

  @override
  Future<Either<Failure, List<ExerciseEntity>>> getExercises({
    int limit = 10,
    int offset = 0,
    String? searchQuery,
    String? bodyPart,
  }) async {
    try {
      final models = await _remoteDataSource.getExercises(
        limit: limit,
        offset: offset,
        searchQuery: searchQuery,
        bodyPart: bodyPart,
      );
      await _localDataSource.cacheExercises(models);
      return Right(models);
    } catch (remoteError) {
      try {
        final localExercises = await _localDataSource.getExercises();
        if (localExercises.isNotEmpty) {
          final filtered = localExercises.where((e) {
            bool matchesSearch = true;
            bool matchesBodyPart = true;

            if (searchQuery != null && searchQuery.isNotEmpty) {
              matchesSearch = e.name.toLowerCase().contains(
                searchQuery.toLowerCase(),
              );
            }

            if (bodyPart != null && bodyPart.isNotEmpty) {
              matchesBodyPart = e.bodyPart == bodyPart;
            }

            return matchesSearch && matchesBodyPart;
          }).toList();

          if (offset >= filtered.length) {
            return const Right([]);
          }
          final end = (offset + limit < filtered.length)
              ? offset + limit
              : filtered.length;
          return Right(filtered.sublist(offset, end));
        }
      } catch (_) {}

      if (remoteError is NotFoundException) {
        return Left(NotFoundFailure(remoteError.message));
      } else if (remoteError is UnauthorizedException) {
        return Left(UnauthorizedFailure(remoteError.message));
      } else if (remoteError is ServerException) {
        return Left(ServerFailure(remoteError.message));
      } else {
        return Left(ServerFailure(remoteError.toString()));
      }
    }
  }
}
