import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/authentication/domain/entities/user_tokens_entity.dart';
import 'package:fourtyninehub/features/authentication/domain/repositories/auth_repository.dart';

class FacebookSignInUseCase extends UseCase<UserTokensEntity, NoParams> {
  final AuthRepository _repository;

  FacebookSignInUseCase(this._repository);

  @override
  Future<Either<Failure, UserTokensEntity>> call(NoParams params) {
    return _repository.signInWithFacebook();
  }
}
