import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/authentication/domain/repositories/auth_repository.dart';

class CheckGuestStateUseCase extends UseCase<bool, NoParams> {
  final AuthRepository repository;

  CheckGuestStateUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    try {
      return Right(await repository.getGuestState());
    } catch (e) {
      return Left(CacheFailure());
    }
  }
}