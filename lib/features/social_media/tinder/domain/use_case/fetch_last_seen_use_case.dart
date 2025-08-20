import 'package:dartz/dartz.dart';
import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../domain/last_seen_entity.dart';
import '../repositories/tinder_repository.dart';

class FetchLastSeenUseCase extends UseCase<LastSeenEntity, String> {
  final TinderRepository _repository;

  FetchLastSeenUseCase(this._repository);

  @override
  Future<Either<Failure, LastSeenEntity>> call(String params) {
    return _repository.fetchLastSeen(params);
  }
}
