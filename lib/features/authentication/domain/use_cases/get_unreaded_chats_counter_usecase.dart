import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/authentication/domain/repositories/auth_repository.dart';

class GetUnreadedChatsCounterUsecase extends UseCase<int, NoParams> {
  final AuthRepository _repository;

  const GetUnreadedChatsCounterUsecase(this._repository);

  @override
  Future<Either<Failure, int>> call(NoParams params) {
    return _repository.getUnreadedChatsCounter();
  }
}
