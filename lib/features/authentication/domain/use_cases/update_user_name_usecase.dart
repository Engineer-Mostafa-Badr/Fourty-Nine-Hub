import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/authentication/domain/repositories/auth_repository.dart';

class UpdateUserNameUseCase extends UseCase<bool, String> {
  final AuthRepository _repo;

  UpdateUserNameUseCase(this._repo);

  @override
  Future<Either<Failure, bool>> call(String params) {
    return _repo.updateUserName(params);
  }
}
