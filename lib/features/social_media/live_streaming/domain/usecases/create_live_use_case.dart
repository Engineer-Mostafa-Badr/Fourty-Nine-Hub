import 'package:dartz/dartz.dart';

import 'package:fourtyninehub/core/error/failure.dart';

import '../../../../../core/abstract/use_case.dart';
import '../entity/live_create_response_entity.dart';
import '../repository/live_repository.dart';

class CreateLiveUseCase extends UseCase<LiveCreateResponseEntity, NoParams> {
  final LiveRepository _liveRepository;

  CreateLiveUseCase({required LiveRepository liveRepository})
      : _liveRepository = liveRepository;
  @override
  Future<Either<Failure, LiveCreateResponseEntity>> call(NoParams params) {
    // TODO: implement call
    throw UnimplementedError();
  }
}
