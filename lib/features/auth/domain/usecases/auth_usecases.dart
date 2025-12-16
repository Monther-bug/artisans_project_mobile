import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

@lazySingleton
class LoginUseCase implements UseCase<UserEntity, LoginParams> {
  final AuthRepository _repository;

  LoginUseCase(this._repository);

  @override
  Future<Either<Failure, UserEntity>> call(LoginParams params) {
    return _repository.signInWithEmail(params.email, params.password);
  }
}

class LoginParams extends Equatable {
  final String email;
  final String password;
  const LoginParams({required this.email, required this.password});
  @override
  List<Object> get props => [email, password];
}

@lazySingleton
class RegisterUseCase implements UseCase<UserEntity, RegisterParams> {
  final AuthRepository _repository;

  RegisterUseCase(this._repository);

  @override
  Future<Either<Failure, UserEntity>> call(RegisterParams params) {
    return _repository.registerWithEmail(params.email, params.password);
  }
}

class RegisterParams extends Equatable {
  final String email;
  final String password;
  const RegisterParams({required this.email, required this.password});
  @override
  List<Object> get props => [email, password];
}

@lazySingleton
class GoogleSignInUseCase implements UseCase<UserEntity, NoParams> {
  final AuthRepository _repository;

  GoogleSignInUseCase(this._repository);

  @override
  Future<Either<Failure, UserEntity>> call(NoParams params) {
    return _repository.signInWithGoogle();
  }
}

@lazySingleton
class SignOutUseCase implements UseCase<void, NoParams> {
  final AuthRepository _repository;

  SignOutUseCase(this._repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) {
    return _repository.signOut();
  }
}

@lazySingleton
class GetCurrentUserUseCase implements UseCase<UserEntity, NoParams> {
  final AuthRepository _repository;

  GetCurrentUserUseCase(this._repository);

  @override
  Future<Either<Failure, UserEntity>> call(NoParams params) {
    return _repository.getCurrentUser();
  }
}
