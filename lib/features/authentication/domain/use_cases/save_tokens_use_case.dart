import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/authentication/domain/entities/user_tokens_entity.dart';
import 'package:fourtyninehub/features/authentication/domain/repositories/auth_repository.dart';

class SaveTokensUseCase extends UseCase<bool, UserTokensEntity?> {
  final AuthRepository _repository;

  const SaveTokensUseCase(this._repository);

  @override
  Future<Either<Failure, bool>> call(UserTokensEntity? params) {
    return _repository.saveUserTokens(params);
  }
}
