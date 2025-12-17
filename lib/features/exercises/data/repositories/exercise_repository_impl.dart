import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/exercise_entity.dart';
import '../../domain/repositories/exercise_repository.dart';
import '../datasources/exercise_remote_data_source.dart';
import '../datasources/exercise_local_data_source.dart';

class ExerciseRepositoryImpl implements ExerciseRepository {
  final ExerciseLocalDataSource _localDataSource;

  ExerciseRepositoryImpl(
    ExerciseRemoteDataSource remoteDataSource,
    this._localDataSource,
  );

  @override
  Future<Either<Failure, List<ExerciseEntity>>> getExercises({
    int limit = 10,
    int offset = 0,
    String? searchQuery,
    String? bodyPart,
  }) async {
    try {
      if (true) {
        final models = await _localDataSource.getExercises(
          limit: limit,
          offset: offset,
          searchQuery: searchQuery,
          bodyPart: bodyPart,
        );
        return Right(models);
      }
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(e.message));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
