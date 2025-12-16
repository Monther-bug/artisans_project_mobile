// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:firebase_auth/firebase_auth.dart' as _i59;
import 'package:get_it/get_it.dart' as _i174;
import 'package:google_sign_in/google_sign_in.dart' as _i116;
import 'package:injectable/injectable.dart' as _i526;

import '../../features/auth/data/datasources/auth_remote_data_source.dart'
    as _i107;
import '../../features/auth/data/repositories/auth_repository_impl.dart'
    as _i153;
import '../../features/auth/domain/repositories/auth_repository.dart' as _i787;
import '../../features/auth/domain/usecases/auth_usecases.dart' as _i46;
import '../../features/exercises/data/datasources/exercise_remote_data_source.dart'
    as _i855;
import '../../features/exercises/data/repositories/exercise_repository_impl.dart'
    as _i340;
import '../../features/exercises/domain/repositories/exercise_repository.dart'
    as _i275;
import '../../features/exercises/domain/usecases/get_exercises_usecase.dart'
    as _i870;
import '../../features/favorites/data/datasources/favorites_local_data_source.dart'
    as _i654;
import '../../features/favorites/data/repositories/favorites_repository_impl.dart'
    as _i144;
import '../../features/favorites/domain/repositories/favorites_repository.dart'
    as _i212;
import '../../features/favorites/domain/usecases/favorites_usecases.dart'
    as _i648;
import '../network/dio_client.dart' as _i667;
import 'firebase_module.dart' as _i616;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final firebaseModule = _$FirebaseModule();
    final networkModule = _$NetworkModule();
    gh.lazySingleton<_i59.FirebaseAuth>(() => firebaseModule.firebaseAuth);
    gh.lazySingleton<_i116.GoogleSignIn>(() => firebaseModule.googleSignIn);
    gh.lazySingleton<_i361.Dio>(() => networkModule.dio);
    gh.lazySingleton<_i855.ExerciseRemoteDataSource>(
      () => _i855.ExerciseRemoteDataSourceImpl(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i654.FavoritesLocalDataSource>(
      () => _i654.FavoritesLocalDataSourceImpl(),
    );
    gh.lazySingleton<_i275.ExerciseRepository>(
      () => _i340.ExerciseRepositoryImpl(gh<_i855.ExerciseRemoteDataSource>()),
    );
    gh.lazySingleton<_i870.GetExercisesUseCase>(
      () => _i870.GetExercisesUseCase(gh<_i275.ExerciseRepository>()),
    );
    gh.lazySingleton<_i212.FavoritesRepository>(
      () => _i144.FavoritesRepositoryImpl(gh<_i654.FavoritesLocalDataSource>()),
    );
    gh.lazySingleton<_i648.GetFavoritesUseCase>(
      () => _i648.GetFavoritesUseCase(gh<_i212.FavoritesRepository>()),
    );
    gh.lazySingleton<_i648.AddFavoriteUseCase>(
      () => _i648.AddFavoriteUseCase(gh<_i212.FavoritesRepository>()),
    );
    gh.lazySingleton<_i648.RemoveFavoriteUseCase>(
      () => _i648.RemoveFavoriteUseCase(gh<_i212.FavoritesRepository>()),
    );
    gh.lazySingleton<_i648.CheckFavoriteUseCase>(
      () => _i648.CheckFavoriteUseCase(gh<_i212.FavoritesRepository>()),
    );
    gh.lazySingleton<_i107.AuthRemoteDataSource>(
      () => _i107.AuthRemoteDataSourceImpl(
        gh<_i59.FirebaseAuth>(),
        gh<_i116.GoogleSignIn>(),
      ),
    );
    gh.lazySingleton<_i787.AuthRepository>(
      () => _i153.AuthRepositoryImpl(gh<_i107.AuthRemoteDataSource>()),
    );
    gh.lazySingleton<_i46.LoginUseCase>(
      () => _i46.LoginUseCase(gh<_i787.AuthRepository>()),
    );
    gh.lazySingleton<_i46.RegisterUseCase>(
      () => _i46.RegisterUseCase(gh<_i787.AuthRepository>()),
    );
    gh.lazySingleton<_i46.GoogleSignInUseCase>(
      () => _i46.GoogleSignInUseCase(gh<_i787.AuthRepository>()),
    );
    gh.lazySingleton<_i46.SignOutUseCase>(
      () => _i46.SignOutUseCase(gh<_i787.AuthRepository>()),
    );
    gh.lazySingleton<_i46.GetCurrentUserUseCase>(
      () => _i46.GetCurrentUserUseCase(gh<_i787.AuthRepository>()),
    );
    return this;
  }
}

class _$FirebaseModule extends _i616.FirebaseModule {}

class _$NetworkModule extends _i667.NetworkModule {}
