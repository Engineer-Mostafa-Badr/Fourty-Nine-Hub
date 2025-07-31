import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/authentication/domain/entities/user_entity.dart';

import '../repositories/auth_repository.dart';

class SignInAsGuestUseCase extends UseCase<UserEntity, NoParams> {
  final AuthRepository repository;

  SignInAsGuestUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(NoParams params) async {
    try {
      await repository.saveGuestState();
      return Right(UserEntity.guest());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}