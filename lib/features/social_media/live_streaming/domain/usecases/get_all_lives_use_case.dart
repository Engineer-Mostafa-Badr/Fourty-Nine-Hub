import 'package:dartz/dartz.dart';

import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/domain/repository/live_repository.dart';

import '../../../../../core/abstract/use_case.dart';
import '../entity/live.dart';

class GetAllLivesUseCase extends UseCase<List<LiveEntity>, NoParams> {
  final LiveRepository _liveRepository;

  GetAllLivesUseCase({required LiveRepository liveRepository})
      : _liveRepository = liveRepository;
  @override
  Future<Either<Failure, List<LiveEntity>>> call(params) {
    // TODO: implement call
    throw UnimplementedError();
  }
}
