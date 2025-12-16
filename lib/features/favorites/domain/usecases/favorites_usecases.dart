import 'package:artisans_project_mobile/features/exercises/domain/entities/exercise_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:artisans_project_mobile/core/errors/failures.dart';
import 'package:artisans_project_mobile/core/usecase/usecase.dart';
import '../repositories/favorites_repository.dart';

@lazySingleton
class GetFavoritesUseCase implements UseCase<List<ExerciseEntity>, NoParams> {
  final FavoritesRepository _repository;
  GetFavoritesUseCase(this._repository);
  @override
  Future<Either<Failure, List<ExerciseEntity>>> call(NoParams params) =>
      _repository.getFavorites();
}

@lazySingleton
class AddFavoriteUseCase implements UseCase<void, ExerciseEntity> {
  final FavoritesRepository _repository;
  AddFavoriteUseCase(this._repository);
  @override
  Future<Either<Failure, void>> call(ExerciseEntity params) =>
      _repository.addFavorite(params);
}

@lazySingleton
class RemoveFavoriteUseCase implements UseCase<void, String> {
  final FavoritesRepository _repository;
  RemoveFavoriteUseCase(this._repository);
  @override
  Future<Either<Failure, void>> call(String params) =>
      _repository.removeFavorite(params);
}

@lazySingleton
class CheckFavoriteUseCase implements UseCase<bool, String> {
  final FavoritesRepository _repository;
  CheckFavoriteUseCase(this._repository);

  Future<bool> execute(String id) => _repository.isFavorite(id);

  @override
  Future<Either<Failure, bool>> call(String params) async {
    return Right(await _repository.isFavorite(params));
  }
}
