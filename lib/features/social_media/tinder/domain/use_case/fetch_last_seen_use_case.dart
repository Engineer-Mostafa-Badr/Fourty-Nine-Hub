import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/social_media/tinder/domain/domain/last_seen_entity.dart';
import 'package:fourtyninehub/features/social_media/tinder/domain/repositories/tinder_repository.dart';



class FetchLastSeenUseCase extends UseCase<LastSeenEntity, String> {
  final TinderRepository _repository;

  FetchLastSeenUseCase(this._repository);

  @override
  Future<Either<Failure, LastSeenEntity>> call(String params) {
    return _repository.fetchLastSeen(params);
  }
}
