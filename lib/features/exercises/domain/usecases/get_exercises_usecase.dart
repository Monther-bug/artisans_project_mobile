import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/exercise_entity.dart';
import '../repositories/exercise_repository.dart';

@lazySingleton
class GetExercisesUseCase
    implements UseCase<List<ExerciseEntity>, GetExercisesParams> {
  final ExerciseRepository _repository;

  GetExercisesUseCase(this._repository);

  @override
  Future<Either<Failure, List<ExerciseEntity>>> call(
    GetExercisesParams params,
  ) {
    return _repository.getExercises(
      limit: params.limit,
      offset: params.offset,
      searchQuery: params.searchQuery,
      bodyPart: params.bodyPart,
    );
  }
}

class GetExercisesParams extends Equatable {
  final int limit;
  final int offset;
  final String? searchQuery;
  final String? bodyPart;

  const GetExercisesParams({
    this.limit = 10,
    this.offset = 0,
    this.searchQuery,
    this.bodyPart,
  });

  @override
  List<Object?> get props => [limit, offset, searchQuery, bodyPart];
}
